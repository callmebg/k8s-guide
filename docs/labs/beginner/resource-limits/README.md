# 实验：资源请求与限制

配套文章：[13. 资源请求与限制](/beginner/13-resource-limits)

## 步骤

1. `bash setup.sh` — 部署三种 QoS 等级的 Pod + OOM 测试 Pod
2. `kubectl get pods -l qos-demo -o custom-columns=NAME:.metadata.name,QOS:.status.qosClass` — 查看 QoS 等级
3. **触发 OOMKilled**：`kubectl exec oom-demo -- sh -c 'dd if=/dev/zero of=/dev/null bs=60M count=1'`
4. `kubectl describe pod oom-demo | grep -A5 "Last State"` — 查看 OOMKilled 详情
5. `kubectl top pod cpu-throttle-demo` — 查看 CPU 限制效果（需要 metrics-server）
6. `bash teardown.sh` — 清理
