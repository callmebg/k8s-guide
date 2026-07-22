#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 部署三层应用
kubectl apply -f "$SCRIPT_DIR/manifests/apps.yaml"
kubectl rollout status deployment/frontend --timeout=60s
kubectl rollout status deployment/backend --timeout=60s
kubectl rollout status deployment/db --timeout=60s

echo ""
echo "✅ 三层应用就绪"
echo ""
echo "测试 frontend → backend:"
kubectl exec deploy/frontend -- curl -s backend:8080 && echo "✅ 可达" || echo "❌ 不可达"
echo ""
echo "测试 frontend → db（默认全通）:"
kubectl exec deploy/frontend -- wget -q -O- db:5432 --timeout=3 && echo "⚠️ 可达（无策略保护！）" || echo "❌ 不可达"
echo ""
echo "应用 NetworkPolicy 隔离策略："
echo "  kubectl apply -f manifests/network-policy.yaml"
