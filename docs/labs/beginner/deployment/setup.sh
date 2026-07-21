#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"

check_deps
create_cluster
wait_ready

echo "📦 创建 Deployment..."
kubectl apply -f "$SCRIPT_DIR/manifests/nginx-deploy.yaml"
echo "⏳ 等待所有 Pod 就绪..."
kubectl rollout status deployment/nginx-deploy --timeout=60s
echo "✅ Deployment 就绪"
kubectl get deployment nginx-deploy
kubectl get pods -l app=nginx
