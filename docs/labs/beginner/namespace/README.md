# 实验：Namespace 与资源配额

配套文章：[11. Namespace 与资源配额](/beginner/11-namespace)

## 步骤

1. `bash setup.sh` — 创建 dev/staging Namespace + ResourceQuota + LimitRange
2. `kubectl get pods -n dev` — 查看 dev 中的 Pod
3. `kubectl get pods -n staging` — 查看 staging 中的 Pod（同名 Deployment，不同 Namespace）
4. `kubectl describe resourcequota dev-quota -n dev` — 查看配额使用情况
5. 测试配额限制：`kubectl run test-quota --image=busybox --restart=Never --requests='cpu=5,memory=10Gi' -n dev`（预期被拒绝）
6. 测试 LimitRange 自动填充：`kubectl run auto-limit --image=busybox --restart=Never -n dev`
7. `kubectl get pod auto-limit -n dev -o jsonpath='{.spec.containers[0].resources}'` — 查看自动填充的资源
8. `bash teardown.sh` — 清理
