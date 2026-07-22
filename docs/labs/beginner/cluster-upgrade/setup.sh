#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

echo ""
echo "✅ 集群就绪"
echo ""
echo "版本信息:"
kubectl version --short 2>/dev/null || kubectl version --output=json | grep -E '"gitVersion"'
echo ""
echo "节点状态:"
kubectl get nodes -o wide
echo ""
echo "证书过期时间:"
docker exec k8s-guide-lab-control-plane kubeadm certs check-expiration 2>/dev/null || echo "  (Kind 集群证书管理略有不同，实验仅演示流程)"
