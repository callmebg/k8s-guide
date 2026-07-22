#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 部署包含 Init Container 和 Sidecar 的 Pod
kubectl apply -f "$SCRIPT_DIR/manifests/init-sidecar-pod.yaml"

echo "⏳ 等待 Pod 就绪..."
kubectl wait --for=condition=ready pod/app-with-init-sidecar --timeout=120s

echo ""
echo "✅ Pod 就绪"
echo ""
echo "Init Container 日志:"
kubectl logs app-with-init-sidecar -c wait-for-svc
echo ""
kubectl logs app-with-init-sidecar -c init-config
echo ""
echo "Pod 状态:"
kubectl get pod app-with-init-sidecar
