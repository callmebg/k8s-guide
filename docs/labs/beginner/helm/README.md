# 实验：Helm 包管理

配套文章：[17. Helm 包管理](/beginner/17-helm)

## 前置条件

- Helm 3 已安装（setup.sh 会自动安装）

## 步骤

1. `bash setup.sh` — 创建集群 + 添加 bitnami 仓库
2. `helm search repo nginx` — 搜索 nginx Chart
3. `helm install my-nginx bitnami/nginx` — 安装 nginx
4. `helm list` — 查看 Release
5. `helm install custom-nginx bitnami/nginx --set replicaCount=2` — 自定义安装
6. `helm upgrade my-nginx bitnami/nginx --set replicaCount=3` — 升级
7. `helm history my-nginx` — 查看版本历史
8. `helm rollback my-nginx 1` — 回滚
9. `helm uninstall my-nginx custom-nginx` — 卸载
10. `bash teardown.sh` — 清理
