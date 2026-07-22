# 实验：探针与健康检查

配套文章：[12. 探针与健康检查](/beginner/12-probes)

## 步骤

1. `bash setup.sh` — 部署带 Liveness + Readiness 探针的 Pod
2. `kubectl get pods -l app=health-demo -w` — 观察 Pod 从 0/1 到 1/1
3. **触发 Liveness 失败**：`kubectl exec deploy/health-demo -- rm /tmp/healthy`
4. `kubectl get pods -l app=health-demo -w` — 观察 RESTARTS 增加
5. **触发 Readiness 失败**：`kubectl exec deploy/health-demo -- rm /tmp/ready`
6. `kubectl get endpoints health-svc` — 观察 Pod 从 Endpoints 移除
7. **恢复**：`kubectl exec deploy/health-demo -- touch /tmp/ready /tmp/healthy`
8. `kubectl get endpoints health-svc` — Pod 重新出现在 Endpoints
9. `bash teardown.sh` — 清理
