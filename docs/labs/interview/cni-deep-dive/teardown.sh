#!/bin/bash
set -euo pipefail
CLUSTER_NAME="cni-lab"
kubectl delete -f "$(cd "$(dirname "$0")" && pwd)/manifests/test-pods.yaml" --ignore-not-found 2>/dev/null
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
delete_cluster
rm -f /tmp/cni-kind-config.yaml
