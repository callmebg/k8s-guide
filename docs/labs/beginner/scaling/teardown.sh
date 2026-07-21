#!/bin/bash
set -euo pipefail
kubectl delete hpa php-apache --ignore-not-found
kubectl delete deployment php-apache --ignore-not-found
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
