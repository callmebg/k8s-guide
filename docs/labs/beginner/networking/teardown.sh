#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
kubectl delete ingress my-ingress --ignore-not-found
kubectl delete service web api --ignore-not-found
kubectl delete deployment web api --ignore-not-found
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
