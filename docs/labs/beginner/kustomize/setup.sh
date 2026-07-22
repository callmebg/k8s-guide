#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 创建 Namespace
kubectl create namespace staging
kubectl create namespace production

echo ""
echo "✅ 集群和 Namespace 就绪"
echo ""
echo "预览 base:"
kubectl kustomize "$SCRIPT_DIR/base/"
echo ""
echo "预览 staging overlay:"
kubectl kustomize "$SCRIPT_DIR/overlays/staging/"
echo ""
echo "预览 production overlay:"
kubectl kustomize "$SCRIPT_DIR/overlays/production/"
