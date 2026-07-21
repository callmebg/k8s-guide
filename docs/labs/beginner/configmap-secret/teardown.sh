#!/bin/bash
set -euo pipefail
kubectl delete pod config-env-pod --ignore-not-found
kubectl delete configmap app-config --ignore-not-found
kubectl delete secret app-secret --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
