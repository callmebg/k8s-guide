#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 创建 RBAC 资源
kubectl apply -f "$SCRIPT_DIR/manifests/rbac-demo.yaml"

# 部署测试应用
kubectl apply -f "$SCRIPT_DIR/manifests/test-app.yaml"
kubectl rollout status deployment/test-app -n dev --timeout=60s

echo "✅ RBAC Demo 就绪"
echo ""
echo "ServiceAccount:"
kubectl get serviceaccount -n dev
echo ""
echo "Role:"
kubectl get role -n dev
echo ""
echo "RoleBinding:"
kubectl get rolebinding -n dev
echo ""
echo "测试 readonly-sa 权限："
TOKEN=$(kubectl create token readonly-sa -n dev)
echo "✅ kubectl get pods (应该成功):"
kubectl --token="$TOKEN" get pods -n dev 2>&1 | head -3
echo "❌ kubectl delete pods (应该被拒绝):"
kubectl --token="$TOKEN" delete pod --all -n dev 2>&1 | head -1
