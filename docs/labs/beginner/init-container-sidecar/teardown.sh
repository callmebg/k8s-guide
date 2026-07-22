#!/bin/bash
set -euo pipefail
kubectl delete pod app-with-init-sidecar --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
