# FeeDispositionModule — 实现说明与待决事项

- 日期：2026-09-04
- 对应 PRD：`PRD-fee-disposition-automation.md`
- 状态：代码完成、单元/fuzz/主网 fork 测试全绿、Slither 已跑；**待工程师审核，未部署**
- 代码：`src/FeeDispositionModule.sol`（Solidity 0.8.28，OpenZeppelin v5.1.0，Foundry 1.8.1）

---

## 1. PRD 与实现的对应关系

| PRD 要求 | 实现 | 备注 |
|---|---|---|
| `accumulatedFeePTC` | `PTC.balanceOf(module)`（view `accumulatedFeePTC()`） | 不另设记账变量，任何转进来的 PTC 都会被处置，不会产生「记账与真实余额脱节」 |
| `threshold` / `burnBps` / `callerIncentiveBps` / `slippageBps` / `lpRecipient` | `Config` struct + `setConfig` / `setLpRecipient`，全部 owner 可改 | 另加 `maxBatch`、`minIncentive`、`minInterval`，理由见 §3 |
| `liquidityBps = 10000 - burnBps` | 隐含在 `computeSplit` 里 | |
| `trigger()` 任何人可调 | `trigger(uint256 minUsdtOut)`，无权限检查，`nonReentrant` + `whenNotPaused` | 参数 `minUsdtOut` 传 0 即等价于 PRD 的无参版本 |
| 销毁 | 转账到 `0x…dEaD` | PTC 无原生 `burn()`（fork 验证：只有 12 个标准 selector） |
| swap `amountOutMin` 来自 `getAmountsOut` − 滑点 | 是；另外要求报价不能比「卖出前现价 × (1 − slippageBps)」更差 | 后一条是**价格冲击上限**，防止阈值配大后一口气砸池 |
| addLiquidity 两侧 `amountMin` 来自当前储备 − 滑点 | 是（swap 之后重读储备再推导） | |
| 余额归零断言 | `_settle` 里逐项对账：PTC 前后差 == 激励 + 销毁 + 卖出 + 配对用量；USDT 同理；不等即 `AccountingMismatch` | PTC 无转账税（fork 验证），所以可以用精确相等 |
| 单事件包含全部金额 | `FeeDisposed(caller, batch, incentive, burned, swappedPtc, usdtReceived, ptcToLiquidity, usdtToLiquidity, lpMinted, ptcCarried, usdtCarried)` | 另有累计统计 `totalBurned` 等，看板可直接读 |
| 激励来源 | **PTC，拆分之前从整批扣除（off the top）** | PRD 悬而未决的点，见 §4 决策 1 |

## 2. 拆分算法（`computeSplit`，纯函数）

```
incentive = max(batch × callerIncentiveBps / 10000, minIncentive)      // 必须 < batch
remainder = batch − incentive
burn      = remainder × burnBps / 10000
liquidity = remainder − burn
swap      = (liquidity − usdtHeldInPtc) / 2   （usdtHeldInPtc 为合约里已有 USDT 按现价折算；首轮为 0）
pair      = liquidity − swap
恒等式     incentive + burn + swap + pair == batch   （fuzz 512 轮验证）
```

`usdtHeldInPtc` 的作用：addLiquidity 总会剩一点 USDT（池子手续费 0.25% + 价格冲击导致两侧比例不完全吻合），
下一轮把这点 USDT 算进去、少卖一点 PTC，尘埃就会被消耗而不是无限累积。测试 `test_UsdtCarryForwardConsumedNextRun` 验证尘埃逐轮缩小。

## 3. PRD 之外新增的三个参数（为什么）

1. **`minIncentive`（激励绝对下限）** — 按比例算的激励在小批次下不够覆盖 gas（见 §5），没有下限就没有外部 keeper。
2. **`maxBatch`（单次处置上限，0 = 不限）** — 如果手续费积压很久（比如后端 claim 停了几周），一次性卖出会超过价格冲击上限而 revert；
   `maxBatch` 让积压分多次、每次都在池子深度之内消化。fork 测试：2M PTC 积压直接 trigger 会 revert（`PriceImpactTooHigh`），
   设 `maxBatch = 100k` 后可分批消化。
3. **`minInterval`（最短间隔）** — PRD「sensitive points」里建议的最小频率限制，减少批次大小/时机的可预测性。

## 4. PRD 悬而未决点的处理

1. **激励从哪里出** → PTC、拆分前扣除。理由：剩余部分严格 30/70，事件数字可直接对账，不用再从 USDT 里切一刀。
2. **`lpRecipient`** → **已决定（Matt，2026-09-04）：LP 销毁，`lpRecipient = 0x…dEaD`。** LP 一经打入即永久不可取回，
   流动性深度在链上可证明。构造函数必填、非零；部署脚本只接受黑洞地址或有代码的合约，EOA 需显式
   `ALLOW_EOA_LP_RECIPIENT=true`（只用于测试网）。个人 MetaMask 地址被明确否决：那等于「一个人随时能撤走流动性」，与 PRD 目的相反。
3. **`threshold` / `slippageBps` 默认值** → 脚本默认 50,000 PTC / 150 bps，见 §5。
4. **MEV** → `slippageBps` + `maxBatch` + `minInterval` + 调用者可传 `minUsdtOut`。**必须说清楚的剩余风险**：
   合约在同一笔交易里先报价再 swap，所以 `slippageBps` 挡不住三明治（攻击者先推价，我们按推过的价报价、按推过的价接受）。
   真正有效的防线是 `minUsdtOut`（引导 cron 用链下报价算出来再传），以及批次本身很小 —— 按当前规模，
   攻击者最多能拿走 `slippageBps × 卖出额`，即 50k PTC 批次约 17.4k PTC ≈ $130 的卖出额 × 1.5% ≈ **$2**，不值得攻击。
   如果未来手续费规模上百倍，再考虑加 TWAP 校验（V2 pair 自带 `price0CumulativeLast`，可以在不改现有接口的前提下追加）。
5. **资金来源（PRD 的核心假设有误）** → 见 §6。

## 5. 参数默认值与经济性（2026-09-04 链上实测）

- PTC/USDT 池：5,100,837 PTC / 38,243 USDT → PTC ≈ **$0.0075**
- BSC gas price：**0.05 gwei**；BNB ≈ $713（WBNB/USDT 池现价）
- `trigger()` 主网 fork 实测 gas：**466,339**（首次调用、冷存储）→ 一次调用 gas 成本 ≈ 0.0000233 BNB ≈ **$0.017**

HANDOFF 里「gas ≈ $0.3–1」的估算已过时（BSC Maxwell 之后 gas price 降到 0.05 gwei）。按 PRD 的 20–50 bps、每天约 3,000 PTC 手续费：

- 阈值 50,000 PTC ≈ 17 天手续费；激励 = max(50k × 0.3%, 150 PTC) = **150 PTC ≈ $1.12**，减 gas 后 keeper 净赚 ≈ $1.10
- 阈值 3,000 PTC（一天）：激励 = max(9 PTC, 150 PTC) = 150 PTC，下限主导；此时激励占批次 5%，太贵

脚本默认：`threshold 50,000 PTC · maxBatch 0 · minIncentive 150 PTC · burnBps 3000 · callerIncentiveBps 30 · slippageBps 150 · minInterval 3600s`。
**这些是建议值，需要 Matt 拍板**，尤其 `threshold`（多久处置一次）和 `minIncentive`（愿意为「有人来按按钮」付多少）。
`slippageBps` 150 含池子 0.25% 手续费，对 50k 批次（卖出 17.4k PTC，占池子 0.34%）绰绰有余。

## 6. 资金来源：手续费在链下扣，不会自动到合约

（来自 HANDOFF §3，已核对 service-thebook 的 `VptcWithDrawService` / `PTCVaultTools`）赎回时 15% 手续费只在数据库
`user_vptc_record.feeNumber` 记账，vault 的 `claim()` 签的是**净额**；手续费 PTC 从未离开 vault。PRD 假设的「vault 把手续费转到模块」不存在。

推荐方案（a）：后端已持有 vault 的 `claimSigner` key，加一个每日任务，把当天已完成赎回的 `feeNumber` 求和，
签一笔 `claim(to = FeeDispositionModule, amount = feeSum, requestId, deadline)`。不改 vault、不加新 key。
**需要工程师用 vault 源码确认**：`claim` 是否限制 `to` / `msg.sender`；`perTxCap` / `dailyCap` / 每地址每日一次的限制是否影响；
合约地址作为 `to` 是否被允许（ERC20 转账到合约没有问题，但要看 vault 有没有 `isContract` 之类的检查）。

## 7. 安全属性

- `Ownable2Step`（两步转移，避免转错地址）、`ReentrancyGuard`、`Pausable`（紧急停止，只影响 trigger）
- owner **不能**取走 PTC / USDT（`rescueToken` 明确拒绝这两个 token）—— 否则「不依赖公司私钥」的承诺就是空话
- 参数上限：激励 ≤ 5%、滑点 ≤ 10%、`minIncentive < threshold`（且 < `maxBatch`），防止误配把机制配死或配成漏洞
- router 授权每次按精确额度给、用完归零
- 只读辅助：`canTrigger()`（cron 先问再发）、`previewTrigger()`（keeper 估算是否值得调用）

## 8. 测试覆盖（对应 PRD 验收标准）

单元 31 项 + fuzz（`forge test --no-match-contract Fork`）；主网 fork 4 项（`--match-contract Fork`）：

- 阈值以下 revert、恰好阈值成功、任意 EOA 可调 ✔
- 拆分到 wei：小 / 大（1e9 PTC）/ 奇数批次精确匹配 PRD 公式；fuzz 恒等式 ✔
- 激励只付一次；`minIncentive` 下限；零激励 ✔
- swap 滑点 revert（router 少给 2%）、1% 内通过；addLiquidity 比例偏移 revert；调用者 `minUsdtOut` 生效 ✔
- 价格冲击过大 revert；`maxBatch` 分批 ✔
- 重入：恶意代币回调里再调 `trigger()`，被 `ReentrancyGuardReentrantCall` 挡住，激励只付一次 ✔
- LP 只到 `lpRecipient`（合约 / 调用者 / owner / router 都为 0）✔
- USDT 结转、`burnBps = 100%`、pause、onlyOwner、Ownable2Step、参数校验、rescue 限制、授权归零 ✔
- **主网 fork 端到端**：从分发钱包转 60k PTC 进合约，随机 EOA 调用 → 黑洞地址增量、池子 PTC 与 k 变深、LP 到 `lpRecipient`、合约只剩尘埃 ✔

**尚未做**（需要 Matt / 工程师）：测试网部署 + BscScan 验证；后端 cron 接入；审计。`lpRecipient` 已定为黑洞地址，不再是阻塞项。

## 9. Slither 0.11.6 结果与分类（`slither . --filter-paths "lib/|test/|script/" --exclude-dependencies`）

无 High / Medium。已修：`divide-before-multiply`（3 处，改为先乘后除）。其余 14 条全部为 Informational / Optimization，逐条说明：

| 检测器 | 位置 | 处理 |
|---|---|---|
| `incorrect-equality` | `_usdtToPtcAtSpot` 的 `== 0` | 零值保护，不是余额比较，误报 |
| `uninitialized-local` | `trigger` 里的 `Run memory r` | 故意留零值，字段随后逐个赋值 |
| `unused-return` | `_reserves` 忽略 `blockTimestampLast` | 不需要该字段 |
| `reentrancy-benign` | `_settle` 在 router 调用之后写累计统计 | 已有 `nonReentrant`；写的只是统计量，且 `test_ReentrancyBlocked` 证明重入被挡 |
| `timestamp` | `minInterval` 比较 + 若干被误归类的普通比较 | `minInterval` 本来就是按区块时间设计的频率限制，矿工能操纵的幅度（秒级）对小时级间隔无意义 |
| `naming-convention` | `PTC` / `USDT` / `ROUTER` / `PAIR` / `PTC_IS_TOKEN0` 用大写 | immutable 用常量风格是项目约定 |
