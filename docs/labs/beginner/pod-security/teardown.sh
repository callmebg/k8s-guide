#!/bin/bash
set -euo pipefail
kubectl delete pod default-pod secure-pod --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
