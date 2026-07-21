#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready
kubectl apply -f "$SCRIPT_DIR/manifests/nginx-deploy.yaml"
kubectl rollout status deployment/nginx --timeout=60s
kubectl apply -f "$SCRIPT_DIR/manifests/nginx-svc.yaml"
echo "✅ Deployment + Service 就绪"
kubectl get services
