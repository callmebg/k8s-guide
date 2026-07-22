#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 创建 CRD
kubectl apply -f "$SCRIPT_DIR/manifests/websiteinfo-crd.yaml"

echo "⏳ 等待 CRD 就绪..."
kubectl wait --for=condition=established crd/websiteinfos.example.com --timeout=30s

echo ""
echo "✅ CRD 就绪"
echo ""
echo "可用的自定义 API 资源:"
kubectl api-resources | grep example
