#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready
kubectl apply -f "$SCRIPT_DIR/manifests/nginx-rs.yaml"
kubectl wait --for=condition=ready pod -l app=nginx-rs --timeout=60s
echo "✅ ReplicaSet 就绪"
kubectl get replicasets
