#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 部署默认 Pod 和安全 Pod
kubectl apply -f "$SCRIPT_DIR/manifests/default-pod.yaml"
kubectl apply -f "$SCRIPT_DIR/manifests/secure-pod.yaml"

echo "⏳ 等待 Pod 就绪..."
kubectl wait --for=condition=ready pod/default-pod --timeout=60s
kubectl wait --for=condition=ready pod/secure-pod --timeout=60s

echo ""
echo "✅ Pod 就绪"
echo ""
echo "默认 Pod 运行用户:"
kubectl exec default-pod -- whoami
echo ""
echo "安全 Pod 运行用户:"
kubectl exec secure-pod -- whoami
