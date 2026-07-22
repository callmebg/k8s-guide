# 实验：Pod Disruption Budget

配套文章：[25. Pod Disruption Budget](/beginner/25-pdb)

## 步骤

1. `bash setup.sh` — 创建集群 + 部署多副本 Deployment + 创建 PDB
2. `kubectl get pdb` — 查看 PDB 状态
3. `kubectl describe pdb app-pdb` — 查看 PDB 详情和 ALLOWED DISRUPTIONS
4. `kubectl rollout restart deployment/my-app` — 触发滚动更新，观察 Pod 替换过程
5. `kubectl get pods -w` — 验证同时不可用的 Pod 不超过 maxUnavailable
6. `kubectl get events --field-selector reason=DisruptionNotAllowed` — 查看被阻止的驱逐事件
7. `bash teardown.sh` — 清理
