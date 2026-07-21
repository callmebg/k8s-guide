#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

echo "💾 创建 PVC + Pod..."
kubectl apply -f "$SCRIPT_DIR/manifests/pvc.yaml"
kubectl apply -f "$SCRIPT_DIR/manifests/pvc-pod.yaml"
kubectl wait --for=condition=ready pod/pvc-pod --timeout=60s
echo "✅ PVC 已绑定，Pod 就绪"
kubectl get pvc
