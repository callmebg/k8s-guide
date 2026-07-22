# 实验：Pod 身份与认证机制

配套文章：[26. Pod 身份与认证机制](/beginner/26-pod-identity)

## 步骤

1. `bash setup.sh` — 创建集群 + 创建 SA + 部署使用该 SA 的 Pod
2. `kubectl exec reader-pod -- ls /var/run/secrets/kubernetes.io/serviceaccount/` — 查看挂载的文件
3. `kubectl exec reader-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token | head -c 100` — 查看 Token 片段
4. `kubectl exec reader-pod -- sh -c 'TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token); curl -sk -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api/v1/namespaces/default/pods'` — 用 Token 访问 API Server
5. `kubectl create token test-sa --duration=1h` — 手动创建 Token
6. 用创建的 Token 尝试访问，验证权限
7. `bash teardown.sh` — 清理
