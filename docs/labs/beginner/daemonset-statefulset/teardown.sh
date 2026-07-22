#!/bin/bash
set -euo pipefail
kubectl delete -f "$(cd "$(dirname "$0")" && pwd)/manifests/" --ignore-not-found
# 清理 StatefulSet 的 PVC
kubectl delete pvc -l app=web-stateful --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
