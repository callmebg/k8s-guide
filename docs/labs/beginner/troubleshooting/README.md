# 实验：排障方法论

配套文章：[19. 排障方法论](/beginner/19-troubleshooting)

## 步骤

1. `bash setup.sh` — 创建 3 个预设故障 Pod
2. `kubectl get pods` — 查看 Pod 状态
3. **场景 1**：`kubectl describe pod pending-pod` → 看 Events 找调度失败原因
4. **场景 2**：`kubectl logs crash-pod --previous` → 看日志找崩溃原因
5. **场景 3**：`kubectl describe pod image-pull-pod` → 看 Events 找镜像拉取失败原因
6. `bash teardown.sh` — 清理

## 答案

- pending-pod：请求了 100 核 CPU + 1000Gi 内存，没有任何节点能满足
- crash-pod：应用需要 DATABASE_URL 环境变量，未设置导致 exit 1
- image-pull-pod：镜像名拼写错误（nginxx → nginx）
