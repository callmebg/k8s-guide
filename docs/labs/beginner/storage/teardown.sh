#!/bin/bash
set -euo pipefail
kubectl delete pod pvc-pod --ignore-not-found
kubectl delete pvc my-pvc --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
