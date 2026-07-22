#!/bin/bash
set -euo pipefail
kubectl delete pod reader-pod --ignore-not-found
kubectl delete sa my-reader test-sa --ignore-not-found
kubectl delete role pod-reader --ignore-not-found
kubectl delete rolebinding reader-binding --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
