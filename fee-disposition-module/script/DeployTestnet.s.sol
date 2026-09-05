// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console2} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FeeDispositionModule} from "../src/FeeDispositionModule.sol";
import {IPancakeRouter02} from "../src/interfaces/IPancakeRouter02.sol";
import {IPancakeFactory} from "../src/interfaces/IPancakeFactory.sol";
import {MockERC20} from "../test/mocks/MockERC20.sol";

/// @notice BSC 测试网（chainId 97）一键部署：测试网上没有 PTC/USDT 池，所以先部署两个测试代币、
///         在 PancakeSwap 测试网 router 上建池并注入与主网同量级的流动性，再部署模块。
///         仅用于验收 PRD 里「测试网端到端」那一条；主网请用 Deploy.s.sol。
///
///   forge script script/DeployTestnet.s.sol --rpc-url https://bsc-testnet-rpc.publicnode.com \
///        --private-key $DEPLOYER_PRIVATE_KEY --broadcast --verify --etherscan-api-key $BSCSCAN_API_KEY
///
///   部署账户需要约 0.05 tBNB（水龙头：https://www.bnbchain.org/en/testnet-faucet）。
contract DeployTestnet is Script {
    /// PancakeSwap V2 测试网 router（factory 0x6725F303…7a17，已在链上核对）
    address constant TESTNET_ROUTER = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;

    function run()
        external
        returns (FeeDispositionModule module, MockERC20 ptc, MockERC20 usdt, address pair)
    {
        require(block.chainid == 97, "testnet only");
        address deployer = msg.sender;
        address owner = vm.envOr("OWNER", deployer);

        vm.startBroadcast();
        ptc = new MockERC20("PromptCoin (testnet)", "tPTC");
        usdt = new MockERC20("Tether (testnet)", "tUSDT");
        // 与主网池同量级：5.1M PTC / 38.2k USDT，价格 ≈ 0.0075
        uint256 poolPtc = 5_100_000e18;
        uint256 poolUsdt = 38_200e18;
        ptc.mint(deployer, poolPtc + 500_000e18); // 多铸 50 万给部署者当「手续费」喂给模块
        usdt.mint(deployer, poolUsdt);
        ptc.approve(TESTNET_ROUTER, poolPtc);
        usdt.approve(TESTNET_ROUTER, poolUsdt);
        IPancakeRouter02(TESTNET_ROUTER).addLiquidity(
            address(ptc), address(usdt), poolPtc, poolUsdt, poolPtc, poolUsdt, deployer, block.timestamp + 600
        );
        pair = IPancakeFactory(IPancakeRouter02(TESTNET_ROUTER).factory()).getPair(address(ptc), address(usdt));

        FeeDispositionModule.Config memory cfg = FeeDispositionModule.Config({
            threshold: vm.envOr("THRESHOLD_PTC", uint256(50_000)) * 1e18,
            maxBatch: 0,
            minIncentive: vm.envOr("MIN_INCENTIVE_PTC", uint256(30)) * 1e18,
            burnBps: 3000,
            callerIncentiveBps: 30,
            slippageBps: 150,
            minInterval: uint32(vm.envOr("MIN_INTERVAL_SECONDS", uint256(3600))),
            twapWindow: uint32(vm.envOr("TWAP_WINDOW_SECONDS", uint256(1800))),
            maxTwapDeviationBps: 300
        });
        module = new FeeDispositionModule(owner, address(ptc), address(usdt), TESTNET_ROUTER, DEAD, cfg);
        vm.stopBroadcast();

        console2.log("tPTC:", address(ptc));
        console2.log("tUSDT:", address(usdt));
        console2.log("pair:", pair);
        console2.log("FeeDispositionModule:", address(module));
        console2.log("owner:", owner);
        console2.log("deployer holds 500k tPTC to feed the module; first trigger after (unix):", block.timestamp + cfg.twapWindow);
    }
}
