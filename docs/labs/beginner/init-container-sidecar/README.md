# 实验：Init Container 与 Sidecar

配套文章：[21. Init Container 与 Sidecar](/beginner/21-init-container-sidecar)

## 步骤

1. `bash setup.sh` — 创建集群 + 部署带 Init Container 和 Sidecar 的 Pod
2. `kubectl get pods -w` — 观察 Init Container 执行顺序（Pending → Init:0/2 → Init:1/2 → Init:2/2 → PodInitializing → Running）
3. `kubectl logs app-with-init-sidecar -c wait-for-svc` — 查看 Init Container 日志
4. `kubectl logs app-with-init-sidecar -c init-config` — 查看第二个 Init 日志
5. `kubectl exec app-with-init-sidecar -c app -- curl -s localhost` — 主容器产生访问日志
6. `kubectl logs app-with-init-sidecar -c log-collector` — 验证 Sidecar 收集到日志
7. `bash teardown.sh` — 清理
