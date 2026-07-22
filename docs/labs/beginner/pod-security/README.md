# 实验：Pod 安全上下文

配套文章：[24. Pod 安全上下文](/beginner/24-pod-security)

## 步骤

1. `bash setup.sh` — 创建集群 + 部署默认 Pod 和安全 Pod
2. `kubectl exec default-pod -- whoami` — 验证默认 Pod 以 root 运行
3. `kubectl exec secure-pod -- whoami` — 验证安全 Pod 以非 root 运行
4. `kubectl exec secure-pod -- touch /tmp/test` — 验证只读文件系统拒绝写入
5. `kubectl exec default-pod -- cat /proc/1/status | grep Cap` — 查看默认 Pod 的能力集
6. `kubectl exec secure-pod -- cat /proc/1/status | grep Cap` — 对比安全 Pod 的能力（更小）
7. `bash teardown.sh` — 清理
