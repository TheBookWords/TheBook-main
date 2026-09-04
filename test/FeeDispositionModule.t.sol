// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {FeeDispositionModule} from "../src/FeeDispositionModule.sol";
import {MockERC20} from "./mocks/MockERC20.sol";
import {MockRouter, MockPair} from "./mocks/MockPancake.sol";
import {ReentrantERC20} from "./mocks/ReentrantERC20.sol";

contract FeeDispositionModuleTest is Test {
    uint256 constant BPS = 10_000;
    // 与 2026-09-04 真实 PTC/USDT 池深度同量级，让本地数字有参考意义
    uint256 constant POOL_PTC = 5_100_000e18;
    uint256 constant POOL_USDT = 38_200e18;

    MockERC20 ptc;
    MockERC20 usdt;
    MockRouter router;
    MockPair pair;
    FeeDispositionModule module;

    address owner = makeAddr("owner");
    address lpLock = makeAddr("lpLock");
    address bob = makeAddr("bob");
    address lpSeeder = makeAddr("lpSeeder");

    FeeDispositionModule.Config cfg;

    function setUp() public {
        ptc = new MockERC20("PromptCoin", "PTC");
        usdt = new MockERC20("Tether", "USDT");
        router = new MockRouter();
        pair = MockPair(router.factoryContract().createPair(address(ptc), address(usdt)));
        ptc.mint(address(pair), POOL_PTC);
        usdt.mint(address(pair), POOL_USDT);
        pair.mint(lpSeeder);

        cfg = FeeDispositionModule.Config({
            threshold: 50_000e18,
            maxBatch: 0,
            minIncentive: 150e18,
            burnBps: 3000,
            callerIncentiveBps: 30,
            slippageBps: 150,
            minInterval: 3600
        });
        module = _deploy(cfg);
    }

    function _deploy(FeeDispositionModule.Config memory c) internal returns (FeeDispositionModule) {
        return new FeeDispositionModule(owner, address(ptc), address(usdt), address(router), lpLock, c);
    }

    function _fund(uint256 amount) internal {
        ptc.mint(address(module), amount);
    }

    function _reserves() internal view returns (uint256 rPtc, uint256 rUsdt) {
        (uint112 r0, uint112 r1,) = pair.getReserves();
        (rPtc, rUsdt) = pair.token0() == address(ptc) ? (uint256(r0), uint256(r1)) : (uint256(r1), uint256(r0));
    }

    // ───────────── 阈值 / 权限 ─────────────

    function test_RevertWhen_BelowThreshold() public {
        _fund(cfg.threshold - 1);
        vm.prank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(FeeDispositionModule.BelowThreshold.selector, cfg.threshold - 1, cfg.threshold)
        );
        module.trigger(0);
    }

    function test_TriggerAtExactThresholdFromRandomEoa() public {
        _fund(cfg.threshold);
        vm.prank(bob);
        module.trigger(0);
        assertEq(module.triggerCount(), 1);
    }

    function test_HappyPath_AllDestinationsMove() public {
        uint256 batch = 60_000e18;
        _fund(batch);
        (uint256 rPtcBefore, uint256 rUsdtBefore) = _reserves();

        vm.prank(bob);
        FeeDispositionModule.Split memory s = module.trigger(0);

        uint256 expectedIncentive = batch * cfg.callerIncentiveBps / BPS; // 180 PTC > minIncentive 150
        assertEq(s.incentive, expectedIncentive, "incentive off the top");
        assertEq(ptc.balanceOf(bob), expectedIncentive, "caller paid");
        assertEq(ptc.balanceOf(module.BURN_ADDRESS()), (batch - expectedIncentive) * cfg.burnBps / BPS, "burned");

        (uint256 rPtcAfter, uint256 rUsdtAfter) = _reserves();
        // 机制先卖 PTC 换 USDT、再把 USDT 连同 PTC 加回去：池子 USDT 基本不变，PTC 与 k 都变深
        assertGt(rPtcAfter, rPtcBefore, "pool PTC grew (swap + LP)");
        assertApproxEqRel(rUsdtAfter, rUsdtBefore, 0.001e18, "pool USDT flat within 0.1%");
        assertGt(rPtcAfter * rUsdtAfter, rPtcBefore * rUsdtBefore, "k deepened");
        assertGt(pair.balanceOf(lpLock), 0, "LP landed at lpRecipient");

        // 合约里只允许留下配对尘埃，PTC 剩余远小于一次配对量
        assertLt(ptc.balanceOf(address(module)), s.pair / 100, "ptc dust only");
        assertLt(usdt.balanceOf(address(module)), 5e18, "usdt dust only");
        assertEq(module.totalBurned(), s.burn);
        assertEq(module.totalIncentivePaid(), s.incentive);
    }

    function test_LpTokensOnlyAtRecipient() public {
        _fund(60_000e18);
        vm.prank(bob);
        module.trigger(0);
        assertGt(pair.balanceOf(lpLock), 0);
        assertEq(pair.balanceOf(bob), 0);
        assertEq(pair.balanceOf(owner), 0);
        assertEq(pair.balanceOf(address(module)), 0);
        assertEq(pair.balanceOf(address(router)), 0);
    }

    // ───────────── 拆分数学 ─────────────

    function test_ComputeSplit_ExactPrdMath_Small() public view {
        _assertPrdSplit(cfg.threshold);
    }

    function test_ComputeSplit_ExactPrdMath_Large() public view {
        _assertPrdSplit(1_000_000_000e18);
    }

    function test_ComputeSplit_ExactPrdMath_Odd() public view {
        _assertPrdSplit(cfg.threshold + 1234567891234567891);
    }

    function _assertPrdSplit(uint256 batch) internal view {
        FeeDispositionModule.Split memory s = module.computeSplit(batch, 0, cfg);
        uint256 inc = batch * cfg.callerIncentiveBps / BPS;
        if (inc < cfg.minIncentive) inc = cfg.minIncentive;
        uint256 remainder = batch - inc;
        uint256 burn = remainder * cfg.burnBps / BPS;
        uint256 liq = remainder - burn;
        assertEq(s.incentive, inc);
        assertEq(s.burn, burn);
        assertEq(s.swap, liq / 2);
        assertEq(s.pair, liq - liq / 2);
        assertEq(s.incentive + s.burn + s.swap + s.pair, batch);
    }

    function testFuzz_ComputeSplit_Identity(
        uint256 batch,
        uint256 usdtHeldInPtc,
        uint16 burnBps,
        uint16 incentiveBps,
        uint256 minIncentive
    ) public view {
        batch = bound(batch, 1, type(uint128).max);
        usdtHeldInPtc = bound(usdtHeldInPtc, 0, type(uint128).max);
        burnBps = uint16(bound(burnBps, 0, BPS));
        incentiveBps = uint16(bound(incentiveBps, 0, module.MAX_CALLER_INCENTIVE_BPS()));
        minIncentive = bound(minIncentive, 0, batch - 1);
        FeeDispositionModule.Config memory c = cfg;
        c.burnBps = burnBps;
        c.callerIncentiveBps = incentiveBps;
        c.minIncentive = minIncentive;
        c.threshold = batch; // 满足校验：minIncentive < threshold

        FeeDispositionModule.Split memory s = module.computeSplit(batch, usdtHeldInPtc, c);

        assertEq(s.incentive + s.burn + s.swap + s.pair, batch, "sum identity");
        assertEq(s.burn, (batch - s.incentive) * burnBps / BPS, "burn exact");
        assertLe(s.swap, s.pair, "never sell more than kept");
        if (usdtHeldInPtc == 0) assertEq(s.swap, (batch - s.incentive - s.burn) / 2, "half split");
    }

    function test_ComputeSplit_RevertWhen_IncentiveEatsBatch() public {
        FeeDispositionModule.Config memory c = cfg;
        c.minIncentive = 100;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.IncentiveExceedsBatch.selector, 100, 100));
        module.computeSplit(100, 0, c);
    }

    // ───────────── 激励 ─────────────

    function test_IncentivePaidOnce_SecondCallReverts() public {
        _fund(cfg.threshold);
        vm.startPrank(bob);
        module.trigger(0);
        uint256 paid = ptc.balanceOf(bob);
        assertEq(paid, cfg.minIncentive, "bps 150 == floor 150 at threshold");
        vm.expectRevert(); // 余额已归零 → BelowThreshold（或 interval），无论哪个都不会二次付款
        module.trigger(0);
        vm.stopPrank();
        assertEq(ptc.balanceOf(bob), paid);
    }

    function test_MinIncentiveFloorApplies() public {
        FeeDispositionModule.Config memory c = cfg;
        c.callerIncentiveBps = 0;
        vm.prank(owner);
        module.setConfig(c);
        _fund(cfg.threshold);
        vm.prank(bob);
        module.trigger(0);
        assertEq(ptc.balanceOf(bob), c.minIncentive);
    }

    function test_ZeroIncentiveAllowed() public {
        FeeDispositionModule.Config memory c = cfg;
        c.callerIncentiveBps = 0;
        c.minIncentive = 0;
        vm.prank(owner);
        module.setConfig(c);
        _fund(cfg.threshold);
        vm.prank(bob);
        module.trigger(0);
        assertEq(ptc.balanceOf(bob), 0);
    }

    // ───────────── 频率 / 批次 ─────────────

    function test_MinInterval() public {
        _fund(cfg.threshold);
        vm.prank(bob);
        module.trigger(0);
        _fund(cfg.threshold);
        vm.prank(bob);
        vm.expectRevert(
            abi.encodeWithSelector(
                FeeDispositionModule.IntervalNotElapsed.selector, uint64(block.timestamp), cfg.minInterval
            )
        );
        module.trigger(0);
        vm.warp(block.timestamp + cfg.minInterval);
        vm.prank(bob);
        module.trigger(0);
        assertEq(module.triggerCount(), 2);
    }

    function test_MaxBatchCapsRun() public {
        FeeDispositionModule.Config memory c = cfg;
        c.maxBatch = 60_000e18;
        vm.prank(owner);
        module.setConfig(c);
        _fund(200_000e18);
        vm.prank(bob);
        FeeDispositionModule.Split memory s = module.trigger(0);
        assertEq(s.batch, 60_000e18);
        assertGe(ptc.balanceOf(address(module)), 140_000e18);
    }

    // ───────────── 滑点 / 价格冲击 ─────────────

    function test_RevertWhen_PriceImpactTooHigh() public {
        // 2M PTC 的批次要卖出 ~700k，占池子 ~14%，远超 1.5%
        _fund(2_000_000e18);
        vm.prank(bob);
        vm.expectPartialRevert(FeeDispositionModule.PriceImpactTooHigh.selector);
        module.trigger(0);
    }

    function test_RevertWhen_RouterUnderdeliversSwap() public {
        router.setSwapPenaltyBps(200); // 比报价少 2%，超过 1.5% 的容忍
        _fund(60_000e18);
        vm.prank(bob);
        vm.expectRevert(bytes("PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT"));
        module.trigger(0);
    }

    function test_SwapWithinSlippagePasses() public {
        router.setSwapPenaltyBps(100); // 1% < 1.5%
        _fund(60_000e18);
        vm.prank(bob);
        module.trigger(0);
        assertEq(module.triggerCount(), 1);
    }

    function test_RevertWhen_LiquidityRatioMoved() public {
        router.setLiquidityRatioSkewBps(300);
        _fund(60_000e18);
        vm.prank(bob);
        vm.expectRevert(bytes("PancakeRouter: INSUFFICIENT_A_AMOUNT"));
        module.trigger(0);
    }

    function test_CallerMinUsdtOutEnforced() public {
        _fund(60_000e18);
        (, uint256 expected) = module.previewTrigger();
        vm.prank(bob);
        vm.expectRevert(bytes("PancakeRouter: INSUFFICIENT_OUTPUT_AMOUNT"));
        module.trigger(expected + 1);

        vm.prank(bob);
        module.trigger(expected); // 精确等于报价也应成功
        assertEq(module.triggerCount(), 1);
    }

    // ───────────── 重入 ─────────────

    function test_ReentrancyBlocked() public {
        ReentrantERC20 evil = new ReentrantERC20();
        MockPair evilPair = MockPair(router.factoryContract().createPair(address(evil), address(usdt)));
        evil.mint(address(evilPair), POOL_PTC);
        usdt.mint(address(evilPair), POOL_USDT);
        evilPair.mint(lpSeeder);
        FeeDispositionModule m =
            new FeeDispositionModule(owner, address(evil), address(usdt), address(router), lpLock, cfg);
        evil.mint(address(m), 60_000e18);
        evil.arm(address(m));

        vm.prank(bob);
        m.trigger(0);

        assertEq(evil.reentryAttempts(), 1, "callback fired");
        assertEq(evil.reentrySucceeded(), 0, "reentry blocked");
        assertEq(bytes4(evil.lastRevertData()), ReentrancyGuard.ReentrancyGuardReentrantCall.selector);
        assertEq(evil.balanceOf(bob), 60_000e18 * 30 / BPS, "incentive paid exactly once");
    }

    // ───────────── USDT 结转 ─────────────

    function test_UsdtCarryForwardConsumedNextRun() public {
        _fund(60_000e18);
        vm.prank(bob);
        module.trigger(0);
        uint256 usdtDust = usdt.balanceOf(address(module));
        assertGt(usdtDust, 0, "first run leaves usdt dust (pool fee/impact)");

        vm.warp(block.timestamp + cfg.minInterval);
        _fund(60_000e18);
        vm.prank(bob);
        FeeDispositionModule.Split memory s = module.trigger(0);
        uint256 liq = 60_000e18 - s.incentive - s.burn;
        assertLt(s.swap, liq / 2, "held usdt offsets swap");
        assertLt(usdt.balanceOf(address(module)), usdtDust, "dust shrinks, not accumulates");
    }

    function test_BurnAll_NoSwapNoLiquidity() public {
        FeeDispositionModule.Config memory c = cfg;
        c.burnBps = 10_000;
        vm.prank(owner);
        module.setConfig(c);
        _fund(60_000e18);
        vm.prank(bob);
        FeeDispositionModule.Split memory s = module.trigger(0);
        assertEq(s.swap, 0);
        assertEq(s.pair, 0);
        assertEq(ptc.balanceOf(address(module)), 0);
        assertEq(pair.balanceOf(lpLock), 0);
        assertEq(ptc.balanceOf(module.BURN_ADDRESS()), 60_000e18 - s.incentive);
    }

    // ───────────── 只读 ─────────────

    function test_CanTriggerStates() public {
        (bool ok, string memory why) = module.canTrigger();
        assertFalse(ok);
        assertEq(why, "below threshold");
        _fund(cfg.threshold);
        (ok,) = module.canTrigger();
        assertTrue(ok);
        vm.prank(bob);
        module.trigger(0);
        _fund(cfg.threshold);
        (ok, why) = module.canTrigger();
        assertFalse(ok);
        assertEq(why, "interval not elapsed");
        vm.prank(owner);
        module.pause();
        (ok, why) = module.canTrigger();
        assertEq(why, "paused");
        assertEq(module.accumulatedFeePTC(), cfg.threshold);
    }

    function test_PreviewMatchesRun() public {
        _fund(60_000e18);
        (FeeDispositionModule.Split memory p, uint256 expectedOut) = module.previewTrigger();
        vm.prank(bob);
        FeeDispositionModule.Split memory s = module.trigger(0);
        assertEq(p.burn, s.burn);
        assertEq(p.swap, s.swap);
        assertGt(expectedOut, 0);
    }

    // ───────────── 管理 ─────────────

    function test_Paused_RevertsTrigger() public {
        vm.prank(owner);
        module.pause();
        _fund(cfg.threshold);
        vm.prank(bob);
        vm.expectRevert(Pausable.EnforcedPause.selector);
        module.trigger(0);
        vm.prank(owner);
        module.unpause();
        vm.prank(bob);
        module.trigger(0);
    }

    function test_OnlyOwner() public {
        vm.startPrank(bob);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, bob));
        module.setConfig(cfg);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, bob));
        module.setLpRecipient(bob);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, bob));
        module.pause();
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, bob));
        module.rescueToken(address(usdt), bob, 1);
        vm.stopPrank();
    }

    function test_Ownable2Step() public {
        vm.prank(owner);
        module.transferOwnership(bob);
        assertEq(module.owner(), owner, "not yet");
        vm.prank(bob);
        module.acceptOwnership();
        assertEq(module.owner(), bob);
    }

    function test_ConfigValidation() public {
        FeeDispositionModule.Config memory c;
        vm.startPrank(owner);
        c = cfg;
        c.threshold = 0;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.InvalidConfig.selector, "threshold=0"));
        module.setConfig(c);
        c = cfg;
        c.burnBps = 10_001;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.InvalidConfig.selector, "burnBps>100%"));
        module.setConfig(c);
        c = cfg;
        c.callerIncentiveBps = 501;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.InvalidConfig.selector, "incentiveBps>max"));
        module.setConfig(c);
        c = cfg;
        c.slippageBps = 1001;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.InvalidConfig.selector, "slippageBps>max"));
        module.setConfig(c);
        c = cfg;
        c.minIncentive = cfg.threshold;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.InvalidConfig.selector, "minIncentive>=threshold"));
        module.setConfig(c);
        c = cfg;
        c.maxBatch = cfg.minIncentive;
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.InvalidConfig.selector, "minIncentive>=maxBatch"));
        module.setConfig(c);
        vm.stopPrank();
    }

    function test_LpRecipientZeroReverts() public {
        vm.prank(owner);
        vm.expectRevert(FeeDispositionModule.ZeroAddress.selector);
        module.setLpRecipient(address(0));
        vm.expectRevert(FeeDispositionModule.ZeroAddress.selector);
        new FeeDispositionModule(owner, address(ptc), address(usdt), address(router), address(0), cfg);
    }

    function test_RescueToken() public {
        MockERC20 stray = new MockERC20("Stray", "STR");
        stray.mint(address(module), 5e18);
        _fund(1e18);
        usdt.mint(address(module), 1e18);
        vm.startPrank(owner);
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.RescueNotAllowed.selector, address(ptc)));
        module.rescueToken(address(ptc), owner, 1e18);
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.RescueNotAllowed.selector, address(usdt)));
        module.rescueToken(address(usdt), owner, 1e18);
        module.rescueToken(address(stray), owner, 5e18);
        vm.stopPrank();
        assertEq(stray.balanceOf(owner), 5e18);
    }

    function test_ApprovalsResetAfterRun() public {
        _fund(60_000e18);
        vm.prank(bob);
        module.trigger(0);
        assertEq(ptc.allowance(address(module), address(router)), 0);
        assertEq(usdt.allowance(address(module), address(router)), 0);
    }
}
