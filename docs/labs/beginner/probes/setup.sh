#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

kubectl apply -f "$SCRIPT_DIR/manifests/health-demo.yaml"
kubectl rollout status deployment/health-demo --timeout=60s

echo "✅ 健康检查 Demo 就绪"
echo ""
echo "Pod 状态："
kubectl get pods -l app=health-demo
echo ""
echo "Service 端点："
kubectl get endpoints health-svc
