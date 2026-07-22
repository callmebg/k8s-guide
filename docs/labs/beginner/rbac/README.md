# 实验：RBAC 权限管理

配套文章：[14. RBAC 权限管理](/beginner/14-rbac)

## 步骤

1. `bash setup.sh` — 创建 Namespace + ServiceAccount + Role + RoleBinding + 测试应用
2. 获取只读 token：`TOKEN=$(kubectl create token readonly-sa -n dev)`
3. ✅ 测试读权限：`kubectl --token=$TOKEN get pods -n dev`
4. ❌ 测试写权限：`kubectl --token=$TOKEN create deployment hack --image=nginx -n dev`（预期 Forbidden）
5. ❌ 测试删除权限：`kubectl --token=$TOKEN delete pod --all -n dev`（预期 Forbidden）
6. 查看内置 ClusterRole：`kubectl get clusterrole | head -20`
7. `bash teardown.sh` — 清理
