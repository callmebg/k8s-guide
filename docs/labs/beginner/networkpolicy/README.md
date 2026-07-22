# 实验：NetworkPolicy 实战

配套文章：[22. NetworkPolicy 实战](/beginner/22-networkpolicy)

## 步骤

1. `bash setup.sh` — 创建集群 + 部署 frontend/backend/database 三层应用
2. `kubectl exec deploy/frontend -- curl -s backend:8080` — 验证默认全部互通
3. `kubectl exec deploy/frontend -- wget -q -O- db:5432 --timeout=5` — 确认可以直连 DB（无策略时）
4. `kubectl apply -f manifests/network-policy.yaml` — 应用 NetworkPolicy
5. `kubectl exec deploy/frontend -- curl -s backend:8080` — 验证仍然允许
6. `kubectl exec deploy/frontend -- wget -q -O- db:5432 --timeout=5` — 验证被拒绝！
7. `kubectl exec deploy/backend -- wget -q -O- db:5432 --timeout=5` — 验证 backend→db 允许
8. `bash teardown.sh` — 清理
