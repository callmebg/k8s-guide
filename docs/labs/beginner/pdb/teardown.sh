#!/bin/bash
set -euo pipefail
kubectl delete pdb app-pdb --ignore-not-found
kubectl delete deployment my-app --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
