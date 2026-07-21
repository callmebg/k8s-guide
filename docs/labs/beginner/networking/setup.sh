#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

echo "🔌 安装 Nginx Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx --timeout=90s

echo "📦 创建应用..."
kubectl apply -f "$SCRIPT_DIR/manifests/apps.yaml"
kubectl rollout status deployment/web --timeout=60s
kubectl rollout status deployment/api --timeout=60s
kubectl apply -f "$SCRIPT_DIR/manifests/ingress.yaml"

echo "✅ 应用 + Ingress 就绪"
kubectl get ingress
