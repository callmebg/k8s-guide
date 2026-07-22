#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 创建 Namespace
kubectl create namespace dev
kubectl create namespace staging

# 在两个 Namespace 中部署相同的 Deployment
kubectl create deployment web --image=nginx:1.27 -n dev
kubectl create deployment web --image=nginx:1.27 -n staging
kubectl rollout status deployment/web -n dev --timeout=60s
kubectl rollout status deployment/web -n staging --timeout=60s

# 应用 ResourceQuota 和 LimitRange
kubectl apply -f "$SCRIPT_DIR/manifests/resource-quota.yaml"
kubectl apply -f "$SCRIPT_DIR/manifests/limit-range.yaml"

echo "✅ Namespace dev + staging 就绪（含 ResourceQuota 和 LimitRange）"
kubectl get namespace dev staging
echo ""
echo "ResourceQuota:"
kubectl describe resourcequota dev-quota -n dev | tail -5
echo ""
echo "LimitRange:"
kubectl describe limitrange dev-limits -n dev | tail -10
