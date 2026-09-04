// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable, Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {IPancakeRouter02} from "./interfaces/IPancakeRouter02.sol";
import {IPancakeFactory} from "./interfaces/IPancakeFactory.sol";
import {IPancakePair} from "./interfaces/IPancakePair.sol";

/// @title FeeDispositionModule
/// @notice 赎回手续费（PTC）的链上处置合约：累计到阈值后，任何人都可以调用 `trigger()`
///         一次性完成「30% 销毁 / 70% 注入 PTC-USDT 流动性」，调用者获得少量 PTC 激励。
/// @dev 设计要点（为什么这么做，而不是别的方案）：
///  - 不修改已上线的 PTCReserveVault，只做伴生合约：vault 没有任何手续费转发逻辑，
///    改 vault 意味着重新审计；本合约只要求「有人把 PTC 转进来」（后端每日签一笔 claim 到本合约即可）。
///  - 所有金额都以调用时的合约 PTC 余额为准，没有独立的 accumulated 状态变量：
///    避免「记账余额」与「真实余额」脱节（任何直接转账都能被处置，也不会出现无法处置的孤儿余额）。
///  - 激励在拆分之前从整批里扣除（off the top）：这样剩余部分严格按 burnBps 拆分，事件里的数字可直接对账，
///    不需要再从 USDT 里切一刀。
///  - 上一轮 addLiquidity 剩下的 USDT 会在下一轮参与配对（按现价折算成 PTC 后少 swap 一点），
///    否则 USDT 尘埃会在合约里无限累积，与「合约余额归零」的验收目标冲突。
///  - 同一笔交易内先报价再 swap，`slippageBps` 对三明治攻击的保护有限（攻击者先推价，我们按推过的价报价）。
///    真正的防线是：`maxBatch` 限制单次卖出规模、`minInterval` 限制频率、以及调用者可传入
///    链下报价得出的 `minUsdtOut`（引导 cron 一定要传）。剩余风险已在工程师说明里列出。
contract FeeDispositionModule is Ownable2Step, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    // ─────────────────────────── 类型 ───────────────────────────

    /// @dev 所有可运营参数集中在一个 struct 里，方便一次性校验彼此的约束关系（见 `_validateConfig`）。
    struct Config {
        /// 合约 PTC 余额达到多少（wei）后 `trigger()` 才可调用
        uint256 threshold;
        /// 单次处置最多处理多少 PTC（wei）；0 表示不限制。用来把单次卖出规模压在池子深度之内
        uint256 maxBatch;
        /// 激励的绝对下限（wei）。BSC 上一次 trigger 的 gas 远高于「万分之几 × 一天的手续费」，
        /// 没有这个下限外部 keeper 永远不会来调用
        uint256 minIncentive;
        /// 销毁比例（bps）。流动性比例 = 10000 - burnBps
        uint16 burnBps;
        /// 调用者激励比例（bps），按整批计算
        uint16 callerIncentiveBps;
        /// swap 与 addLiquidity 的最大可接受滑点（bps），同时也是本次 swap 相对现价的最大价格冲击
        uint16 slippageBps;
        /// 两次 trigger 之间的最短间隔（秒），0 表示不限制
        uint32 minInterval;
    }

    /// @dev 一次处置的金额拆分。恒等式：incentive + burn + swap + pair == batch。
    struct Split {
        uint256 batch;
        uint256 incentive;
        uint256 burn;
        uint256 swap;
        uint256 pair;
    }

    // ─────────────────────────── 常量 / 不可变量 ───────────────────────────

    uint256 public constant BPS = 10_000;
    /// @dev 激励上限 5%、滑点上限 10%：防止 owner 误配把整批手续费当激励发出去，或把滑点放到毫无保护的程度
    uint16 public constant MAX_CALLER_INCENTIVE_BPS = 500;
    uint16 public constant MAX_SLIPPAGE_BPS = 1_000;
    /// @dev PTC 没有原生 burn()，销毁 = 转到公认的黑洞地址
    address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    IERC20 public immutable PTC;
    IERC20 public immutable USDT;
    IPancakeRouter02 public immutable ROUTER;
    IPancakePair public immutable PAIR;
    /// @dev 池子里 token0/token1 的顺序由地址大小决定，部署时定死，避免每次 getReserves 后再比较
    bool public immutable PTC_IS_TOKEN0;

    // ─────────────────────────── 状态 ───────────────────────────

    Config public config;
    /// @notice LP 代币的接收地址（销毁地址或锁仓合约）。绝不是调用者
    address public lpRecipient;
    uint64 public lastTriggerAt;
    uint256 public triggerCount;

    /// @dev 累计统计，供 Treasury 看板直接读取，不必回放事件
    uint256 public totalBurned;
    uint256 public totalIncentivePaid;
    uint256 public totalPtcToLiquidity;
    uint256 public totalUsdtToLiquidity;
    uint256 public totalLpMinted;

    // ─────────────────────────── 事件 ───────────────────────────

    event FeeDisposed(
        address indexed caller,
        uint256 batch,
        uint256 incentive,
        uint256 burned,
        uint256 swappedPtc,
        uint256 usdtReceived,
        uint256 ptcToLiquidity,
        uint256 usdtToLiquidity,
        uint256 lpMinted,
        uint256 ptcCarried,
        uint256 usdtCarried
    );
    event ConfigUpdated(Config config);
    event LpRecipientUpdated(address indexed previous, address indexed current);
    event TokenRescued(address indexed token, address indexed to, uint256 amount);

    // ─────────────────────────── 错误 ───────────────────────────

    error ZeroAddress();
    error PairNotFound();
    error BelowThreshold(uint256 balance, uint256 threshold);
    error IntervalNotElapsed(uint64 lastTriggerAt, uint32 minInterval);
    error IncentiveExceedsBatch(uint256 incentive, uint256 batch);
    error PriceImpactTooHigh(uint256 quotedOut, uint256 minAcceptableOut);
    error InsufficientOutput(uint256 received, uint256 minRequired);
    error AccountingMismatch();
    error InvalidConfig(string reason);
    error RescueNotAllowed(address token);

    // ─────────────────────────── 构造 ───────────────────────────

    constructor(
        address initialOwner,
        address ptc,
        address usdt,
        address router,
        address lpRecipient_,
        Config memory initialConfig
    ) Ownable(initialOwner) {
        if (ptc == address(0) || usdt == address(0) || router == address(0)) revert ZeroAddress();
        PTC = IERC20(ptc);
        USDT = IERC20(usdt);
        ROUTER = IPancakeRouter02(router);
        address pair = IPancakeFactory(ROUTER.factory()).getPair(ptc, usdt);
        if (pair == address(0)) revert PairNotFound();
        PAIR = IPancakePair(pair);
        PTC_IS_TOKEN0 = PAIR.token0() == ptc;

        _setLpRecipient(lpRecipient_);
        _setConfig(initialConfig);
    }

    // ─────────────────────────── 核心：trigger ───────────────────────────

    /// @notice 任何地址都可调用。把当前累计的手续费 PTC 按配置一次性处置完毕。
    /// @param minUsdtOut 调用者自带的 swap 最低产出（来自链下报价）。传 0 则只依赖链上报价 − 滑点；
    ///        引导 cron 必须传链下报价得出的值，这是对三明治攻击唯一真正有效的防线。
    function trigger(uint256 minUsdtOut) external nonReentrant whenNotPaused returns (Split memory s) {
        Config memory c = config;
        Run memory r;
        r.ptcBefore = PTC.balanceOf(address(this));
        r.usdtBefore = USDT.balanceOf(address(this));

        if (r.ptcBefore < c.threshold) revert BelowThreshold(r.ptcBefore, c.threshold);
        if (c.minInterval != 0 && lastTriggerAt != 0 && block.timestamp < uint256(lastTriggerAt) + c.minInterval) {
            revert IntervalNotElapsed(lastTriggerAt, c.minInterval);
        }

        // 先改状态再做外部调用（CEI）；nonReentrant 之外再多一道保险
        lastTriggerAt = uint64(block.timestamp);
        triggerCount += 1;

        uint256 batch = (c.maxBatch != 0 && r.ptcBefore > c.maxBatch) ? c.maxBatch : r.ptcBefore;
        (r.reservePtc, r.reserveUsdt) = _reserves();
        s = computeSplit(batch, _usdtToPtcAtSpot(r.usdtBefore, r.reservePtc, r.reserveUsdt), c);

        if (s.incentive != 0) PTC.safeTransfer(msg.sender, s.incentive);
        if (s.burn != 0) PTC.safeTransfer(BURN_ADDRESS, s.burn);

        if (s.swap != 0) {
            r.usdtOut = _swapPtcForUsdt(s.swap, minUsdtOut, r.reservePtc, r.reserveUsdt, c.slippageBps);
        }

        uint256 usdtAvailable = r.usdtBefore + r.usdtOut;
        if (s.pair != 0 && usdtAvailable != 0) {
            (r.ptcUsed, r.usdtUsed, r.lpMinted) = _addLiquidity(s.pair, usdtAvailable, c.slippageBps);
        }

        _settle(s, r, usdtAvailable);
    }

    /// @dev trigger 的中间量集中放在 memory struct 里，否则局部变量太多会触发 stack too deep
    struct Run {
        uint256 ptcBefore;
        uint256 usdtBefore;
        uint256 reservePtc;
        uint256 reserveUsdt;
        uint256 usdtOut;
        uint256 ptcUsed;
        uint256 usdtUsed;
        uint256 lpMinted;
    }

    /// @dev 对账 + 统计 + 事件。余额必须精确对得上账：PTC 已验证无转账税，任何差异都说明有人动了手脚
    function _settle(Split memory s, Run memory r, uint256 usdtAvailable) internal {
        uint256 ptcAfter = PTC.balanceOf(address(this));
        uint256 usdtAfter = USDT.balanceOf(address(this));
        if (ptcAfter != r.ptcBefore - s.incentive - s.burn - s.swap - r.ptcUsed) revert AccountingMismatch();
        if (usdtAfter != usdtAvailable - r.usdtUsed) revert AccountingMismatch();

        totalBurned += s.burn;
        totalIncentivePaid += s.incentive;
        totalPtcToLiquidity += r.ptcUsed;
        totalUsdtToLiquidity += r.usdtUsed;
        totalLpMinted += r.lpMinted;

        emit FeeDisposed(
            msg.sender,
            s.batch,
            s.incentive,
            s.burn,
            s.swap,
            r.usdtOut,
            r.ptcUsed,
            r.usdtUsed,
            r.lpMinted,
            ptcAfter,
            usdtAfter
        );
    }

    // ─────────────────────────── 只读辅助 ───────────────────────────

    /// @notice 当前待处置的手续费 PTC（即合约余额）
    function accumulatedFeePTC() external view returns (uint256) {
        return PTC.balanceOf(address(this));
    }

    /// @notice 供引导 cron / keeper 在发交易前判断，避免白白花 gas 去 revert
    function canTrigger() external view returns (bool callable, string memory reason) {
        Config memory c = config;
        if (paused()) return (false, "paused");
        uint256 bal = PTC.balanceOf(address(this));
        if (bal < c.threshold) return (false, "below threshold");
        if (c.minInterval != 0 && lastTriggerAt != 0 && block.timestamp < uint256(lastTriggerAt) + c.minInterval) {
            return (false, "interval not elapsed");
        }
        return (true, "");
    }

    /// @notice 预览下一次 trigger 的拆分和预计换到的 USDT（用于 keeper 估算是否值得调用）
    function previewTrigger() external view returns (Split memory s, uint256 expectedUsdtOut) {
        Config memory c = config;
        uint256 bal = PTC.balanceOf(address(this));
        uint256 batch = (c.maxBatch != 0 && bal > c.maxBatch) ? c.maxBatch : bal;
        (uint256 reservePtc, uint256 reserveUsdt) = _reserves();
        s = computeSplit(batch, _usdtToPtcAtSpot(USDT.balanceOf(address(this)), reservePtc, reserveUsdt), c);
        if (s.swap != 0) expectedUsdtOut = ROUTER.getAmountsOut(s.swap, _pathPtcToUsdt())[1];
    }

    /// @notice 纯函数拆分，便于链下复算与 fuzz 测试。
    /// @param usdtHeldInPtc 合约里已有 USDT 按现价折算的 PTC 数量：这部分不需要再 swap，直接参与配对
    function computeSplit(uint256 batch, uint256 usdtHeldInPtc, Config memory c) public pure returns (Split memory s) {
        s.batch = batch;
        s.incentive = batch * c.callerIncentiveBps / BPS;
        if (s.incentive < c.minIncentive) s.incentive = c.minIncentive;
        if (s.incentive >= batch) revert IncentiveExceedsBatch(s.incentive, batch);

        uint256 remainder = batch - s.incentive;
        s.burn = remainder * c.burnBps / BPS;
        uint256 liquidity = remainder - s.burn;
        // 目标是 swap 后手里的 USDT 价值 ≈ 留下的 PTC 价值；已持有的 USDT 先抵掉一部分需要卖出的 PTC
        s.swap = liquidity > usdtHeldInPtc ? (liquidity - usdtHeldInPtc) / 2 : 0;
        s.pair = liquidity - s.swap;
    }

    // ─────────────────────────── Owner 管理 ───────────────────────────

    function setConfig(Config calldata newConfig) external onlyOwner {
        _setConfig(newConfig);
    }

    function setLpRecipient(address newRecipient) external onlyOwner {
        _setLpRecipient(newRecipient);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /// @notice 只允许救援误转进来的其它代币。PTC 与 USDT 是机制本身的资金，owner 也不能取走，
    ///         否则「不依赖公司私钥」的承诺就不成立。
    function rescueToken(address token, address to, uint256 amount) external onlyOwner {
        if (token == address(PTC) || token == address(USDT)) revert RescueNotAllowed(token);
        if (to == address(0)) revert ZeroAddress();
        IERC20(token).safeTransfer(to, amount);
        emit TokenRescued(token, to, amount);
    }

    // ─────────────────────────── 内部 ───────────────────────────

    function _swapPtcForUsdt(
        uint256 amountIn,
        uint256 callerMinOut,
        uint256 reservePtc,
        uint256 reserveUsdt,
        uint16 slippageBps
    ) internal returns (uint256 usdtOut) {
        address[] memory path = _pathPtcToUsdt();
        uint256 quoted = ROUTER.getAmountsOut(amountIn, path)[1];
        // 价格冲击上限：本次卖出相对「卖出前现价」不能比 slippageBps 更差（含池子手续费）。
        // 这一步同时防止 threshold 配得太大时一口气砸穿池子。
        // 先乘后除：uint112 储备 × 1e4 远在 uint256 范围内，避免两次除法叠加的截断
        uint256 minAcceptable = amountIn * reserveUsdt * (BPS - slippageBps) / reservePtc / BPS;
        if (quoted < minAcceptable) revert PriceImpactTooHigh(quoted, minAcceptable);

        uint256 minOut = quoted * (BPS - slippageBps) / BPS;
        if (callerMinOut > minOut) minOut = callerMinOut;

        PTC.forceApprove(address(ROUTER), amountIn);
        uint256[] memory amounts =
            ROUTER.swapExactTokensForTokens(amountIn, minOut, path, address(this), block.timestamp);
        usdtOut = amounts[amounts.length - 1];
        // Router 自己也会校验 amountOutMin，这里再兜一层，防范非标准 router 返回值造假
        if (usdtOut < minOut) revert InsufficientOutput(usdtOut, minOut);
    }

    function _addLiquidity(uint256 ptcDesired, uint256 usdtDesired, uint16 slippageBps)
        internal
        returns (uint256 ptcUsed, uint256 usdtUsed, uint256 lpMinted)
    {
        // 最小值按「swap 之后的当前储备」推导：同一笔交易内没人能再动价格，
        // 这里的下限用于防御非标准 router，而不是防御价格波动
        (uint256 reservePtc, uint256 reserveUsdt) = _reserves();
        uint256 usdtOptimal = ptcDesired * reserveUsdt / reservePtc;
        uint256 ptcMin;
        uint256 usdtMin;
        if (usdtOptimal <= usdtDesired) {
            ptcMin = ptcDesired * (BPS - slippageBps) / BPS;
            usdtMin = ptcDesired * reserveUsdt * (BPS - slippageBps) / reservePtc / BPS;
        } else {
            ptcMin = usdtDesired * reservePtc * (BPS - slippageBps) / reserveUsdt / BPS;
            usdtMin = usdtDesired * (BPS - slippageBps) / BPS;
        }

        PTC.forceApprove(address(ROUTER), ptcDesired);
        USDT.forceApprove(address(ROUTER), usdtDesired);
        (ptcUsed, usdtUsed, lpMinted) = ROUTER.addLiquidity(
            address(PTC), address(USDT), ptcDesired, usdtDesired, ptcMin, usdtMin, lpRecipient, block.timestamp
        );
        // 未用完的授权归零，不给 router 留任何余量
        PTC.forceApprove(address(ROUTER), 0);
        USDT.forceApprove(address(ROUTER), 0);
    }

    function _reserves() internal view returns (uint256 reservePtc, uint256 reserveUsdt) {
        (uint112 r0, uint112 r1,) = PAIR.getReserves();
        (reservePtc, reserveUsdt) = PTC_IS_TOKEN0 ? (uint256(r0), uint256(r1)) : (uint256(r1), uint256(r0));
    }

    function _usdtToPtcAtSpot(uint256 usdtAmount, uint256 reservePtc, uint256 reserveUsdt)
        internal
        pure
        returns (uint256)
    {
        if (usdtAmount == 0 || reserveUsdt == 0) return 0;
        return usdtAmount * reservePtc / reserveUsdt;
    }

    function _pathPtcToUsdt() internal view returns (address[] memory path) {
        path = new address[](2);
        path[0] = address(PTC);
        path[1] = address(USDT);
    }

    function _setLpRecipient(address newRecipient) internal {
        if (newRecipient == address(0)) revert ZeroAddress();
        emit LpRecipientUpdated(lpRecipient, newRecipient);
        lpRecipient = newRecipient;
    }

    function _setConfig(Config memory c) internal {
        _validateConfig(c);
        config = c;
        emit ConfigUpdated(c);
    }

    function _validateConfig(Config memory c) internal pure {
        if (c.threshold == 0) revert InvalidConfig("threshold=0");
        if (c.burnBps > BPS) revert InvalidConfig("burnBps>100%");
        if (c.callerIncentiveBps > MAX_CALLER_INCENTIVE_BPS) revert InvalidConfig("incentiveBps>max");
        if (c.slippageBps > MAX_SLIPPAGE_BPS) revert InvalidConfig("slippageBps>max");
        // 激励下限必须严格小于任何可能的批次大小，否则 computeSplit 会永久 revert，机制停摆
        if (c.minIncentive >= c.threshold) revert InvalidConfig("minIncentive>=threshold");
        if (c.maxBatch != 0 && c.minIncentive >= c.maxBatch) revert InvalidConfig("minIncentive>=maxBatch");
    }
}
