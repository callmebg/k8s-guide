#!/bin/bash
set -euo pipefail
helm uninstall my-nginx --ignore-not-found 2>/dev/null || true
helm uninstall custom-nginx --ignore-not-found 2>/dev/null || true
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
