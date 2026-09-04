#!/usr/bin/env bash
# 引导 cron 参考脚本（cast 版）：每日跑一次；阈值未到时退出码 0、不发交易。
# 环境变量：MODULE（合约地址）、BSC_RPC_URL、RELAYER_KEY（只从密钥管理/环境注入，严禁写进仓库）
set -euo pipefail
: "${MODULE:?MODULE unset}" "${BSC_RPC_URL:?BSC_RPC_URL unset}" "${RELAYER_KEY:?RELAYER_KEY unset}"

read -r callable reason < <(cast call "$MODULE" "canTrigger()(bool,string)" --rpc-url "$BSC_RPC_URL" | tr '\n' ' ')
if [ "$callable" != "true" ]; then
  echo "skip: $reason"
  exit 0
fi

# previewTrigger 返回 (Split, expectedUsdtOut)；最后一个值就是预计换到的 USDT
expected_out=$(cast call "$MODULE" "previewTrigger()((uint256,uint256,uint256,uint256,uint256),uint256)" --rpc-url "$BSC_RPC_URL" | tail -1)
slippage_bps=$(cast call "$MODULE" "config()(uint256,uint256,uint256,uint16,uint16,uint16,uint32)" --rpc-url "$BSC_RPC_URL" | sed -n '6p')
min_out=$(( expected_out * (10000 - slippage_bps) / 10000 ))

echo "trigger: expectedOut=$expected_out minUsdtOut=$min_out"
cast send "$MODULE" "trigger(uint256)" "$min_out" --rpc-url "$BSC_RPC_URL" --private-key "$RELAYER_KEY"
