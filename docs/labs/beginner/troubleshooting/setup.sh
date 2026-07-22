#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

kubectl apply -f "$SCRIPT_DIR/manifests/faults.yaml"

echo "等待故障 Pod 出现异常状态..."
sleep 10

echo "✅ 故障场景就绪"
echo ""
echo "当前 Pod 状态："
kubectl get pods
echo ""
echo "你的任务：用排障五步法诊断每个 Pod 的问题"
echo "  1. pending-pod     → 为什么调度不上去？"
echo "  2. crash-pod       → 为什么反复重启？"
echo "  3. image-pull-pod  → 为什么镜像拉不下来？"
