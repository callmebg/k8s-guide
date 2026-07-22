#!/bin/bash
set -euo pipefail
kubectl delete -f "$(cd "$(dirname "$0")" && pwd)/manifests/" --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
