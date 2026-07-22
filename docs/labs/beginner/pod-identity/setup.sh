#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 创建 ServiceAccount 和 RBAC
kubectl apply -f "$SCRIPT_DIR/manifests/sa-rbac.yaml"

# 部署使用该 SA 的 Pod
kubectl apply -f "$SCRIPT_DIR/manifests/reader-pod.yaml"
kubectl wait --for=condition=ready pod/reader-pod --timeout=60s

echo ""
echo "✅ Pod 身份 Demo 就绪"
echo ""
echo "ServiceAccount:"
kubectl get sa my-reader test-sa
echo ""
echo "Pod 使用的 SA:"
kubectl get pod reader-pod -o jsonpath='{.spec.serviceAccountName}'
