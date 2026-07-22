#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../../common/kind-base.sh"
check_deps
create_cluster
wait_ready

kubectl apply -f "$SCRIPT_DIR/manifests/jobs.yaml"

echo "等待 Job 创建..."
sleep 3

echo "✅ Job + CronJob Demo 就绪"
echo ""
echo "Jobs:"
kubectl get jobs
echo ""
echo "CronJobs:"
kubectl get cronjobs
echo ""
echo "Pods:"
kubectl get pods -l 'job-name in (pi-calc, fail-job)'
