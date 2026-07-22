#!/bin/bash
set -euo pipefail
kubectl delete cronjob heartbeat --ignore-not-found
kubectl delete job pi-calc fail-job --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
