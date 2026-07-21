#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready
kubectl apply -f "$SCRIPT_DIR/manifests/app-config.yaml"
kubectl apply -f "$SCRIPT_DIR/manifests/config-env-pod.yaml"
kubectl wait --for=condition=ready pod/config-env-pod --timeout=60s
echo "✅ ConfigMap + Pod 就绪"
