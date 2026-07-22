# 实验：Kustomize 配置管理

配套文章：[28. Kustomize 配置管理](/beginner/28-kustomize)

## 步骤

1. `bash setup.sh` — 创建集群 + 创建 staging/production Namespace
2. `kubectl kustomize base/` — 预览 base 渲染结果
3. `kubectl kustomize overlays/staging/` — 预览 staging overlay
4. `kubectl kustomize overlays/production/` — 预览 production overlay
5. `kubectl apply -k overlays/staging/` — 部署 staging
6. `kubectl apply -k overlays/production/` — 部署 production
7. `kubectl get deploy -n staging` vs `kubectl get deploy -n production` — 对比差异
8. `kubectl get configmap -n production` — 查看带 hash 的 ConfigMap 名称
9. `bash teardown.sh` — 清理
