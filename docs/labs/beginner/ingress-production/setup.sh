#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
# Kind 集群默认不装 Ingress Controller，需要手动安装
create_cluster
wait_ready

# 安装 Nginx Ingress Controller
echo "📦 安装 Nginx Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
echo "⏳ 等待 Ingress Controller 就绪..."
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller --timeout=120s

# 创建自签名 TLS 证书
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=localhost" 2>/dev/null
kubectl create secret tls app-tls-secret --key=/tmp/tls.key --cert=/tmp/tls.crt

# 部署应用
kubectl apply -f "$SCRIPT_DIR/manifests/apps.yaml"
kubectl rollout status deployment/app-v1 --timeout=60s
kubectl rollout status deployment/app-v2 --timeout=60s
kubectl rollout status deployment/api-service --timeout=60s

# 应用 Ingress 规则
kubectl apply -f "$SCRIPT_DIR/manifests/ingress.yaml"

echo ""
echo "✅ Ingress 生产环境就绪"
echo ""
echo "测试：curl -k https://localhost/"
