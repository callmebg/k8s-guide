#!/bin/bash
set -euo pipefail
kubectl delete ingress --all --ignore-not-found
kubectl delete secret app-tls-secret --ignore-not-found
kubectl delete deployment app-v1 app-v2 api-service --ignore-not-found
kubectl delete service app-v1 app-v2 api-service --ignore-not-found
rm -f /tmp/tls.key /tmp/tls.crt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
