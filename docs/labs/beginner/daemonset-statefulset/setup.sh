#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

# 部署 DaemonSet
kubectl apply -f "$SCRIPT_DIR/manifests/daemonset.yaml"

# 部署 StatefulSet
kubectl apply -f "$SCRIPT_DIR/manifests/statefulset.yaml"

echo "等待 Pod 就绪..."
kubectl rollout status daemonset/node-agent --timeout=60s
kubectl rollout status statefulset/web-stateful --timeout=120s

echo "✅ DaemonSet + StatefulSet 就绪"
echo ""
echo "DaemonSet（每个节点一个）："
kubectl get pods -l app=node-agent -o wide
echo ""
echo "StatefulSet（固定身份 + 有序创建）："
kubectl get pods -l app=web-stateful -o wide
