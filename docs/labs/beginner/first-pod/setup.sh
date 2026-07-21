#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"

check_deps
create_cluster
wait_ready

echo "📦 创建示例 Pod..."
kubectl apply -f "$SCRIPT_DIR/manifests/pod.yaml"
echo "⏳ 等待 Pod 就绪..."
kubectl wait --for=condition=ready pod/my-first-pod --timeout=60s
echo "✅ Pod 已就绪"
kubectl get pod my-first-pod
