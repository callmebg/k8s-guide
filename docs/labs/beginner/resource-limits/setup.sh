#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

kubectl apply -f "$SCRIPT_DIR/manifests/qos-demo.yaml"
kubectl apply -f "$SCRIPT_DIR/manifests/oom-demo.yaml"
kubectl apply -f "$SCRIPT_DIR/manifests/cpu-throttle-demo.yaml"

echo "等待 Pod 就绪..."
kubectl wait --for=condition=Ready pod/guaranteed pod/burstable pod/besteffort pod/oom-demo pod/cpu-throttle-demo --timeout=60s

echo "✅ 资源限制 Demo 就绪"
echo ""
echo "QoS 等级："
kubectl get pods -l qos-demo -o custom-columns=\
NAME:.metadata.name,\
QOS:.status.qosClass,\
CPU_REQ:.spec.containers[0].resources.requests.cpu,\
MEM_REQ:.spec.containers[0].resources.requests.memory,\
CPU_LIM:.spec.containers[0].resources.limits.cpu,\
MEM_LIM:.spec.containers[0].resources.limits.memory
