#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 安装 Nginx Ingress Controller
echo "📦 安装 Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller --timeout=120s

# 安装 metrics-server（HPA 需要）
echo "📦 安装 metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl -n kube-system rollout status deployment/metrics-server --timeout=120s

# 创建 Namespace
kubectl apply -f "$SCRIPT_DIR/manifests/namespace.yaml"

# 部署所有组件
echo "📦 部署微服务栈..."
kubectl apply -f "$SCRIPT_DIR/manifests/"

echo "⏳ 等待所有组件就绪..."
kubectl -n prod rollout status deployment/frontend --timeout=60s
kubectl -n prod rollout status deployment/backend --timeout=60s
kubectl -n prod rollout status deployment/redis --timeout=60s
kubectl -n prod rollout status statefulset/postgres --timeout=60s

echo ""
echo "✅ 微服务部署完成！"
echo ""
echo "组件状态:"
kubectl get all -n prod
echo ""
echo "NetworkPolicy:"
kubectl get networkpolicy -n prod
echo ""
echo "PDB:"
kubectl get pdb -n prod
