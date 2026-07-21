#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
CLUSTER_NAME="cni-lab"

check_deps

# 创建多节点 Kind 集群
cat > /tmp/cni-kind-config.yaml << 'KIND'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
KIND

KIND_CONFIG=/tmp/cni-kind-config.yaml create_cluster
wait_ready

echo "📦 部署测试 Pod（每个节点一个）..."
kubectl apply -f "$SCRIPT_DIR/manifests/test-pods.yaml"
kubectl wait --for=condition=ready pod -l app=cni-test --timeout=60s

echo "✅ 多节点集群 + 测试 Pod 就绪"
kubectl get pods -o wide -l app=cni-test
