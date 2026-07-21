# 实验：ConfigMap 与 Secret

配套文章：[07. ConfigMap 与 Secret](/beginner/07-configmap-secret)

## 步骤

1. `bash setup.sh` — 创建 ConfigMap + 环境变量注入 Pod
2. `kubectl logs config-env-pod` — 验证环境变量（预期：`LOG_LEVEL=info APP_COLOR=blue`）
3. 创建 Secret：`kubectl create secret generic app-secret --from-literal=DB_PASSWORD=supersecret`
4. 查看 Secret：`kubectl get secret app-secret -o yaml`
5. `bash teardown.sh` — 清理
