#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 安装 Metrics Server（Kind 需要 --kubelet-insecure-tls）
echo "安装 Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
kubectl rollout status deployment/metrics-server -n kube-system --timeout=120s

# 部署示例应用
kubectl apply -f "$SCRIPT_DIR/manifests/demo.yaml"
kubectl rollout status deployment/log-generator --timeout=60s

# 等待 Metrics Server 采集数据（通常需要 30-60 秒）
echo "等待 Metrics Server 采集数据（约 30 秒）..."
sleep 30

echo "✅ 日志与监控 Demo 就绪"
echo ""
echo "节点资源使用："
kubectl top nodes 2>/dev/null || echo "（Metrics Server 可能还在采集，稍后再试）"
echo ""
echo "Pod 列表："
kubectl get pods
