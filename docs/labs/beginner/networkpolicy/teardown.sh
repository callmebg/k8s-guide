#!/bin/bash
set -euo pipefail
kubectl delete networkpolicy --all --ignore-not-found
kubectl delete deployment frontend backend db --ignore-not-found
kubectl delete service frontend backend db --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
