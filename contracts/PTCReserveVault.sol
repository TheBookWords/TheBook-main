// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title PTCReserveVault
 * @notice The Prompt Protocol 面向用户的 PTC 提现储备金库。
 *
 * 定位：只做一件事——证明并托管平台承诺留给用户的 PTC（挖矿 25% + 任务 25%，
 * 共 50 亿），并且只允许这些 PTC 流向"用户提现"这一个用途。
 *
 * 提现走 EIP-712 签名领取模式：后端审核通过一笔提现后，用 claimSigner 私钥为其
 * 签发一张凭证（谁、多少钱、单号、有效期到什么时候），谁把这张凭证提交给 claim()/
 * batchClaim() 都能兑现——不要求必须由某个特定账号发起转账，是"验证凭证有效性"
 * 而不是"听某个账号指挥转账"。
 *
 * - claim()：单笔领取，用于快速通道等需要立即到账的场景。
 * - batchClaim()：一笔交易里打包多笔凭证一起领取，用于标准通道等对到账速度不敏感、
 *   靠合并交易分摊手续费换取更低费率的场景。两者共用同一套 requestId 防重放记录，
 *   不会跨接口重复放款。
 *
 * 安全设计：
 * - Owner 建议为多签钱包，负责换 Signer/Guardian、调整限额、发起紧急提取；
 *   紧急提取强制走"提案 -> 等待时间锁 -> 执行"，全程链上可见。
 * - Guardian（可选）只能立即暂停，不能恢复、不能转账，用于第一时间止损。
 * - claimSigner 私钥是全合约最关键的一把钥匙：一旦泄露，攻击者不需要碰任何转账
 *   权限，自己签一张假凭证、自己提交上链就能把钱取走，务必用 KMS/HSM 等方式保管，
 *   且应与负责提交交易、只管付 gas 的账号（relayer）分开存放。
 * - 限额为 0 视为"未配置、禁止提现"（fail-closed），而不是"无限制"，
 *   避免忘记配置限额时被误当成"不限额"。
 */
contract PTCReserveVault is Ownable, Pausable, ReentrancyGuard, EIP712 {
    using SafeERC20 for IERC20;

    // ------------------------------------------------------------------
    // 错误类型
    // ------------------------------------------------------------------
    error ZeroAddress();
    error InvalidAmount();
    error Unauthorized();
    error RequestIdUsed();
    error ExceedsPerTxCap();
    error ExceedsDailyCap();
    error InsufficientVaultBalance();
    error SignerNotConfigured();
    error InvalidSignature();
    error SignatureExpired();
    error EmptyBatch();
    error ArrayLengthMismatch();
    error NoEmergencyWithdrawPending();
    error EmergencyWithdrawNotReady();
    error UserDailyLimitReached();

    // ------------------------------------------------------------------
    // 基础状态
    // ------------------------------------------------------------------

    /// PTC 代币地址（不可更改）
    IERC20 public immutable ptc;

    /// 紧急提取的强制等待时长（部署时确定，不可更改，避免被临时调短）
    uint256 public immutable emergencyWithdrawDelay;

    /// 签发提现凭证的地址；address(0) 表示暂停接受任何新凭证（已放款的不受影响）
    /// @dev 命名为 claimSigner 而非 signer：ethers.js/web3.js 的 Contract 实例
    ///      自带一个名为 signer 的保留属性（指当前发交易的账号），如果 ABI 里
    ///      也叫 signer，会被库的内置属性直接遮盖，导致 vault.signer() 读不到值。
    address public claimSigner;

    /// 可立即暂停（但不能恢复/转账）的地址；address(0) 表示未设置
    address public guardian;

    /// 单笔提现上限；0 表示尚未配置，禁止提现（fail-closed）
    uint256 public perTxCap;

    /// 单日累计提现上限；0 表示尚未配置，禁止提现（fail-closed）
    uint256 public dailyCap;

    /// 历史累计提现总量（claim + batchClaim 之和），供外部看板展示
    uint256 public totalWithdrawn;

    /// 当前额度计算所在的"天"（block.timestamp / 1 days）
    uint256 private _currentDayIndex;

    /// 当前这一天已使用的额度
    uint256 private _dailyUsed;

    /// 提现单号是否已被使用；claim/batchClaim共用同一份记录，防止重复放款
    mapping(bytes32 => bool) public usedRequestId;

    /// 每个用户最近一次成功提现所在的"天"（block.timestamp / 1 days）；
    /// 用于限制"同一用户每天只能成功提现一次"，对齐产品侧的业务规则。
    /// 与 dailyCap 是两道不同的防线：dailyCap 挡的是"claimSigner 被盗后一天最多能被
    /// 掏走多少"（全局无上限次数，攻击者可以换很多个收款地址绕开这道），这道防线挡的
    /// 是"同一个用户/同一个地址一天被重复放款"（即便是自己人操作失误、同一笔请求被
    /// 意外重复签名两次，也不会被同一个地址领两次）。
    mapping(address => uint256) private _userLastWithdrawDay;

    struct EmergencyWithdrawal {
        address to;
        uint256 amount;
        uint256 unlockTime;
    }

    /// 当前待执行的紧急提取提案（同一时间只能有一笔在排队）
    EmergencyWithdrawal public pendingEmergencyWithdrawal;

    bytes32 private constant CLAIM_TYPEHASH =
        keccak256("ClaimRequest(address user,uint256 amount,bytes32 requestId,uint256 deadline)");

    // ------------------------------------------------------------------
    // 事件
    // ------------------------------------------------------------------
    event Deposited(address indexed from, uint256 amount, uint256 timestamp);
    event Claimed(address indexed user, uint256 amount, bytes32 indexed requestId, uint256 timestamp);
    event SignerUpdated(address indexed oldSigner, address indexed newSigner);
    event GuardianUpdated(address indexed oldGuardian, address indexed newGuardian);
    event CapsUpdated(uint256 perTxCap, uint256 dailyCap);
    event EmergencyWithdrawProposed(address indexed to, uint256 amount, uint256 unlockTime);
    event EmergencyWithdrawExecuted(address indexed to, uint256 amount);
    event EmergencyWithdrawCancelled(address indexed to, uint256 amount);

    // ------------------------------------------------------------------
    // 修饰符
    // ------------------------------------------------------------------
    modifier onlyOwnerOrGuardian() {
        if (msg.sender != owner() && msg.sender != guardian) revert Unauthorized();
        _;
    }

    // ------------------------------------------------------------------
    // 构造函数
    // ------------------------------------------------------------------
    /**
     * @param _ptc PTC 代币合约地址
     * @param _claimSigner 初始签名地址，不允许零地址（部署时必须已经能签发凭证）
     * @param _guardian 初始 Guardian，可传 address(0) 表示暂不设置
     * @param _perTxCap 初始单笔提现上限（最小单位，含代币精度）
     * @param _dailyCap 初始单日累计提现上限（最小单位，含代币精度）
     * @param _emergencyWithdrawDelay 紧急提取时间锁时长（秒），建议 >= 48 小时
     *
     * @dev Owner 由 Ownable(msg.sender) 设为部署账号，部署后应尽快通过
     *      transferOwnership() 转交给正式的多签钱包，正式转入大额资金前完成。
     */
    constructor(
        address _ptc,
        address _claimSigner,
        address _guardian,
        uint256 _perTxCap,
        uint256 _dailyCap,
        uint256 _emergencyWithdrawDelay
    ) Ownable(msg.sender) EIP712("PTCReserveVault", "1") {
        if (_ptc == address(0)) revert ZeroAddress();
        if (_claimSigner == address(0)) revert ZeroAddress();

        ptc = IERC20(_ptc);
        claimSigner = _claimSigner;
        guardian = _guardian;
        perTxCap = _perTxCap;
        dailyCap = _dailyCap;
        emergencyWithdrawDelay = _emergencyWithdrawDelay;
    }

    // ------------------------------------------------------------------
    // 存款
    // ------------------------------------------------------------------
    /**
     * @notice 向金库存入 PTC（需先 approve）。也可以直接用标准 ERC20 transfer
     *         转入本合约地址，效果相同，只是不会触发 Deposited 事件、不便对账。
     */
    function deposit(uint256 amount) external nonReentrant {
        if (amount == 0) revert InvalidAmount();
        ptc.safeTransferFrom(msg.sender, address(this), amount);
        emit Deposited(msg.sender, amount, block.timestamp);
    }

    // ------------------------------------------------------------------
    // 签名领取提现
    // ------------------------------------------------------------------
    /**
     * @notice 使用 EIP-712 签名领取单笔提现。claimSigner 未配置时恒定回退。
     * @dev user 作为显式参数而非 msg.sender，允许后端代付 gas 帮用户提交，
     *      也允许用户自己提交同一份凭证。
     */
    function claim(address user, uint256 amount, bytes32 requestId, uint256 deadline, bytes calldata signature)
        external
        whenNotPaused
        nonReentrant
    {
        _verifyAndReserveClaim(user, amount, requestId, deadline, signature);
        ptc.safeTransfer(user, amount);
        emit Claimed(user, amount, requestId, block.timestamp);
    }

    /**
     * @notice 一笔交易里打包提交多份凭证，逐一验证、逐一放款，用于把很多用户的
     *         提现合并成一笔交易、分摊手续费的场景（如标准通道）。
     * @dev 整批原子执行：只要其中一份凭证无效（签名/过期/单号已用/超限额/余额不足），
     *      整笔交易回滚，不会出现"部分放款、部分失败"。请在提交前确保批次内每份
     *      凭证仍然有效（尤其是 deadline 不要设得太紧）。
     */
    function batchClaim(
        address[] calldata users,
        uint256[] calldata amounts,
        bytes32[] calldata requestIds,
        uint256[] calldata deadlines,
        bytes[] calldata signatures
    ) external whenNotPaused nonReentrant {
        uint256 len = users.length;
        if (len == 0) revert EmptyBatch();
        if (
            amounts.length != len || requestIds.length != len || deadlines.length != len
                || signatures.length != len
        ) revert ArrayLengthMismatch();

        for (uint256 i = 0; i < len; i++) {
            _verifyAndReserveClaim(users[i], amounts[i], requestIds[i], deadlines[i], signatures[i]);
            ptc.safeTransfer(users[i], amounts[i]);
            emit Claimed(users[i], amounts[i], requestIds[i], block.timestamp);
        }
    }

    /// @dev claim/batchClaim共用的签名校验 + 记账逻辑：签名合法性、有效期、
    ///      requestId防重放、单笔/单日限额、金库余额是否充足；通过后立即标记状态，
    ///      再由外层执行转账。
    function _verifyAndReserveClaim(
        address user,
        uint256 amount,
        bytes32 requestId,
        uint256 deadline,
        bytes calldata signature
    ) private {
        if (claimSigner == address(0)) revert SignerNotConfigured();
        if (block.timestamp > deadline) revert SignatureExpired();

        bytes32 digest = _hashTypedDataV4(
            keccak256(abi.encode(CLAIM_TYPEHASH, user, amount, requestId, deadline))
        );
        address recovered = ECDSA.recover(digest, signature);
        if (recovered != claimSigner) revert InvalidSignature();

        _validateAndReserve(user, amount, requestId);
    }

    /// @dev 地址/金额合法性、requestId防重放、单用户每日限次、单笔/单日限额、
    ///      金库余额是否充足。
    function _validateAndReserve(address user, uint256 amount, bytes32 requestId) private {
        if (user == address(0)) revert ZeroAddress();
        if (amount == 0) revert InvalidAmount();
        if (usedRequestId[requestId]) revert RequestIdUsed();
        if (amount > perTxCap) revert ExceedsPerTxCap();
        if (ptc.balanceOf(address(this)) < amount) revert InsufficientVaultBalance();

        uint256 today = block.timestamp / 1 days;
        if (_userLastWithdrawDay[user] == today) revert UserDailyLimitReached();
        _userLastWithdrawDay[user] = today;

        usedRequestId[requestId] = true;
        _consumeDailyCap(amount);
        totalWithdrawn += amount;
    }

    function _consumeDailyCap(uint256 amount) private {
        uint256 today = block.timestamp / 1 days;
        if (today != _currentDayIndex) {
            _currentDayIndex = today;
            _dailyUsed = 0;
        }
        _dailyUsed += amount;
        if (_dailyUsed > dailyCap) revert ExceedsDailyCap();
    }

    // ------------------------------------------------------------------
    // 管理员操作（Owner，建议为多签钱包）
    // ------------------------------------------------------------------
    /// @dev newSigner 允许传 address(0)，用于临时暂停接受新凭证（不影响已经上链的历史记录）
    function setSigner(address newSigner) external onlyOwner {
        emit SignerUpdated(claimSigner, newSigner);
        claimSigner = newSigner;
    }

    /// @dev newGuardian 允许传 address(0)，用于关闭该角色
    function setGuardian(address newGuardian) external onlyOwner {
        emit GuardianUpdated(guardian, newGuardian);
        guardian = newGuardian;
    }

    function setCaps(uint256 newPerTxCap, uint256 newDailyCap) external onlyOwner {
        perTxCap = newPerTxCap;
        dailyCap = newDailyCap;
        emit CapsUpdated(newPerTxCap, newDailyCap);
    }

    // ------------------------------------------------------------------
    // 熔断
    // ------------------------------------------------------------------
    /// @notice Owner 或 Guardian 均可立即暂停提现（deposit 不受影响）
    function pause() external onlyOwnerOrGuardian {
        _pause();
    }

    /// @notice 只有 Owner 能恢复
    function unpause() external onlyOwner {
        _unpause();
    }

    // ------------------------------------------------------------------
    // 紧急提取（多签提案 + 强制等待 + 全程公开）
    // ------------------------------------------------------------------
    /**
     * @notice 发起一笔紧急提取提案，进入 emergencyWithdrawDelay 时间锁倒计时。
     *         用于合约迁移等极端场景，正常业务不应该用到这个函数。
     */
    function proposeEmergencyWithdraw(address to, uint256 amount) external onlyOwner {
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert InvalidAmount();

        uint256 unlockTime = block.timestamp + emergencyWithdrawDelay;
        pendingEmergencyWithdrawal = EmergencyWithdrawal({to: to, amount: amount, unlockTime: unlockTime});
        emit EmergencyWithdrawProposed(to, amount, unlockTime);
    }

    /// @notice 时间锁到期后执行紧急提取
    function executeEmergencyWithdraw() external onlyOwner nonReentrant {
        EmergencyWithdrawal memory w = pendingEmergencyWithdrawal;
        if (w.amount == 0) revert NoEmergencyWithdrawPending();
        if (block.timestamp < w.unlockTime) revert EmergencyWithdrawNotReady();

        delete pendingEmergencyWithdrawal;
        ptc.safeTransfer(w.to, w.amount);
        emit EmergencyWithdrawExecuted(w.to, w.amount);
    }

    /// @notice 撤销尚未执行的紧急提取提案；Owner 或 Guardian 均可调用
    /// @dev 只能撤销、不能转账，即使 Owner 被攻破恶意发起提案，Guardian 也能在
    ///      时间锁到期前拦下来，不需要等待多签响应。
    function cancelEmergencyWithdraw() external onlyOwnerOrGuardian {
        EmergencyWithdrawal memory w = pendingEmergencyWithdrawal;
        if (w.amount == 0) revert NoEmergencyWithdrawPending();

        delete pendingEmergencyWithdrawal;
        emit EmergencyWithdrawCancelled(w.to, w.amount);
    }

    // ------------------------------------------------------------------
    // 只读 / 看板数据
    // ------------------------------------------------------------------
    function vaultBalance() external view returns (uint256) {
        return ptc.balanceOf(address(this));
    }

    /// @notice 当前这一天已使用的额度（只读，不修改状态）
    function dailyUsedToday() external view returns (uint256) {
        uint256 today = block.timestamp / 1 days;
        if (today != _currentDayIndex) return 0;
        return _dailyUsed;
    }

    /// @notice 某个用户今天是否已经成功提现过（只读，不修改状态）
    function hasWithdrawnToday(address user) external view returns (bool) {
        return _userLastWithdrawDay[user] == block.timestamp / 1 days;
    }
}
