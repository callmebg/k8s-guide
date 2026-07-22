#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 安装 Gateway API CRD（标准版）
echo "📦 安装 Gateway API CRD..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

# 等待 CRD 就绪
kubectl wait --for=condition=established crd/gateways.gateway.networking.k8s.io --timeout=60s
kubectl wait --for=condition=established crd/httproutes.gateway.networking.k8s.io --timeout=60s

# 安装 Nginx Gateway Fabric（最简单的 Gateway Controller）
echo "📦 安装 Nginx Gateway Fabric..."
kubectl apply -f https://github.com/nginxinc/nginx-gateway-fabric/releases/download/v1.6.2/crds.yaml
kubectl apply -f https://github.com/nginxinc/nginx-gateway-fabric/releases/download/v1.6.2/nginx-gateway.yaml

echo "⏳ 等待 Nginx Gateway Controller 就绪..."
kubectl -n nginx-gateway rollout status deployment/nginx-gateway --timeout=120s

# 创建后端服务
kubectl create deployment web --image=nginx:1.27
kubectl expose deployment web --port=80
kubectl rollout status deployment/web --timeout=60s

kubectl create deployment api --image=hashicorp/http-echo -- -text="Hello from API"
kubectl expose deployment api --port=5678 --target-port=5678
kubectl rollout status deployment/api --timeout=60s

echo ""
echo "✅ Gateway API 环境就绪"
echo ""
echo "可用 GatewayClass:"
kubectl get gatewayclass
