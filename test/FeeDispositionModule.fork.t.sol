// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FeeDispositionModule} from "../src/FeeDispositionModule.sol";
import {IPancakePair} from "../src/interfaces/IPancakePair.sol";

/// @dev BSC 主网 fork 端到端：真实 PTC、真实 PancakeSwap V2 池、真实 router。
///      需要 BSC_RPC_URL（默认公共节点，限流时会失败，重跑即可）。
contract FeeDispositionModuleForkTest is Test {
    address constant PTC = 0x7291B049dC9A16bC75BaD51B0e0AA9EA99cCA2fa;
    address constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address constant ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address constant PAIR = 0x056D41E1022Fd21B51E02c819907f1A0385ce423;
    address constant DISTRIBUTION_WALLET = 0xbB7309e8798b2Ae40592DB315C1a14E64715A53c;
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;

    FeeDispositionModule module;
    address owner = makeAddr("owner");
    address lpLock = makeAddr("lpLock");
    address keeper = makeAddr("keeper");
    FeeDispositionModule.Config cfg;

    function setUp() public {
        vm.createSelectFork(vm.envOr("BSC_RPC_URL", string("https://bsc-dataseed.binance.org")));
        cfg = FeeDispositionModule.Config({
            threshold: 50_000e18,
            maxBatch: 0,
            minIncentive: 30e18,
            burnBps: 3000,
            callerIncentiveBps: 30,
            slippageBps: 150,
            minInterval: 3600,
            twapWindow: 1800,
            maxTwapDeviationBps: 300
        });
        module = new FeeDispositionModule(owner, PTC, USDT, ROUTER, lpLock, cfg);
        assertEq(address(module.PAIR()), PAIR, "factory resolved the live pair");
        vm.warp(block.timestamp + cfg.twapWindow);
    }

    function _fund(uint256 amount) internal {
        vm.prank(DISTRIBUTION_WALLET);
        IERC20(PTC).transfer(address(module), amount);
    }

    function _reserves() internal view returns (uint256 rPtc, uint256 rUsdt) {
        (uint112 r0, uint112 r1,) = IPancakePair(PAIR).getReserves();
        (rPtc, rUsdt) = module.PTC_IS_TOKEN0() ? (uint256(r0), uint256(r1)) : (uint256(r1), uint256(r0));
    }

    function testFork_EndToEnd_RandomEoaTriggers() public {
        uint256 batch = 60_000e18;
        _fund(batch);
        uint256 deadBefore = IERC20(PTC).balanceOf(DEAD);
        (uint256 rPtcBefore, uint256 rUsdtBefore) = _reserves();
        uint256 lpBefore = IERC20(PAIR).balanceOf(lpLock);

        (, uint256 expectedOut) = module.previewTrigger();
        // 模拟 cron：带上链下报价 − 滑点 作为硬下限
        uint256 minOut = expectedOut * (10_000 - cfg.slippageBps) / 10_000;

        vm.prank(keeper);
        FeeDispositionModule.Split memory s = module.trigger(minOut);

        uint256 incentive = batch * 30 / 10_000;
        assertEq(IERC20(PTC).balanceOf(keeper), incentive, "keeper incentive");
        assertEq(IERC20(PTC).balanceOf(DEAD) - deadBefore, (batch - incentive) * 3000 / 10_000, "burn delta");

        (uint256 rPtcAfter, uint256 rUsdtAfter) = _reserves();
        assertGt(rPtcAfter, rPtcBefore, "pool PTC deepened");
        assertApproxEqRel(rUsdtAfter, rUsdtBefore, 0.001e18, "pool USDT flat within 0.1%");
        assertGt(rPtcAfter * rUsdtAfter, rPtcBefore * rUsdtBefore, "k deepened");
        assertGt(IERC20(PAIR).balanceOf(lpLock), lpBefore, "LP at lpRecipient");
        assertEq(IERC20(PAIR).balanceOf(address(module)), 0, "no LP stuck in module");
        assertEq(IERC20(PAIR).balanceOf(keeper), 0, "no LP to caller");

        assertLt(IERC20(PTC).balanceOf(address(module)), s.pair / 100, "PTC dust only");
        assertLt(IERC20(USDT).balanceOf(address(module)), 2e18, "USDT dust only");
        assertEq(module.totalLpMinted(), IERC20(PAIR).balanceOf(lpLock) - lpBefore);
    }

    function testFork_AtomicSandwichRejectedOnRealPool() public {
        _fund(60_000e18);
        ForkSandwich attacker = new ForkSandwich(module);
        vm.prank(DISTRIBUTION_WALLET);
        IERC20(PTC).transfer(address(attacker), 400_000e18);
        vm.expectPartialRevert(FeeDispositionModule.PriceDeviatesFromTwap.selector);
        attacker.attack(400_000e18);
    }

    function testFork_TwapViewMatchesSpotOnQuietPool() public view {
        (uint256 twap, uint32 age) = module.twapPrice();
        (uint256 rPtc, uint256 rUsdt) = _reserves();
        assertGe(age, cfg.twapWindow);
        assertApproxEqRel(twap, rUsdt * 2 ** 112 / rPtc, 0.02e18, "fork block is a snapshot; twap ~ spot");
    }

    function testFork_RevertWhen_BelowThreshold() public {
        _fund(1_000e18);
        vm.prank(keeper);
        vm.expectRevert(abi.encodeWithSelector(FeeDispositionModule.BelowThreshold.selector, 1_000e18, cfg.threshold));
        module.trigger(0);
    }

    function testFork_BigBacklogAutoCappedOnRealPool() public {
        // 2M PTC 积压：一次卖出会砸池 ~14%。按真实储备自动封顶到 ~1.27% 冲击，剩余留到下一轮
        _fund(2_000_000e18);
        uint256 cap = module.maxSafeBatch();
        vm.prank(keeper);
        FeeDispositionModule.Split memory s = module.trigger(0);
        assertEq(s.batch, cap);
        assertLt(cap, 300_000e18, "cap is a small fraction of the 5.1M pool");
        assertGt(IERC20(PTC).balanceOf(address(module)), 1_700_000e18, "backlog carried");
    }

    function testFork_MaxBatchLetsBigBacklogDrainSafely() public {
        FeeDispositionModule.Config memory c = cfg;
        c.maxBatch = 100_000e18;
        vm.prank(owner);
        module.setConfig(c);
        _fund(2_000_000e18);
        vm.prank(keeper);
        FeeDispositionModule.Split memory s = module.trigger(0);
        assertEq(s.batch, 100_000e18);
    }
}

interface IRouterLike {
    function swapExactTokensForTokens(uint256, uint256, address[] calldata, address, uint256)
        external
        returns (uint256[] memory);
}

contract ForkSandwich {
    FeeDispositionModule immutable module;

    constructor(FeeDispositionModule m) {
        module = m;
    }

    function attack(uint256 amount) external {
        IERC20(module.PTC()).approve(address(module.ROUTER()), amount);
        address[] memory path = new address[](2);
        path[0] = address(module.PTC());
        path[1] = address(module.USDT());
        IRouterLike(address(module.ROUTER())).swapExactTokensForTokens(amount, 0, path, address(this), block.timestamp);
        module.trigger(0);
    }
}
