# 实验：日志与监控

配套文章：[18. 日志与监控](/beginner/18-logging-monitoring)

## 步骤

1. `bash setup.sh` — 安装 Metrics Server + 部署日志生成器
2. `kubectl top nodes` — 查看节点资源使用
3. `kubectl top pods --all-namespaces --sort-by=memory | head -10` — 查看 Top Pod
4. `kubectl logs -l app=log-generator -f` — 实时跟踪日志
5. `kubectl logs -l app=log-generator --since=1m` — 查看最近 1 分钟日志
6. `kubectl logs multi-container-pod -c app` — 查看多容器 Pod 的指定容器日志
7. `kubectl logs multi-container-pod -c sidecar` — 查看另一个容器
8. `bash teardown.sh` — 清理
