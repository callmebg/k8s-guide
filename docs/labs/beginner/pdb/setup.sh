#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 部署应用
kubectl apply -f "$SCRIPT_DIR/manifests/app.yaml"
kubectl rollout status deployment/my-app --timeout=60s

# 创建 PDB
kubectl apply -f "$SCRIPT_DIR/manifests/pdb.yaml"

echo ""
echo "✅ PDB Demo 就绪"
echo ""
echo "PDB 状态:"
kubectl get pdb
echo ""
kubectl describe pdb app-pdb
