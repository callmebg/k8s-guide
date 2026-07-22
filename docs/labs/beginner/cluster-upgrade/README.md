# 实验：集群升级与维护

配套文章：[29. 集群升级与维护](/beginner/29-cluster-upgrade)

## 步骤

1. `bash setup.sh` — 创建多节点 Kind 集群
2. `kubectl version` — 查看当前版本
3. `kubectl get nodes -o wide` — 查看节点状态
4. `docker exec k8s-guide-lab-control-plane kubeadm certs check-expiration` — 检查证书过期
5. 模拟 etcd 备份：`docker exec ... etcdctl snapshot save ...`
6. 模拟 cordon + uncordon：`kubectl cordon <node>` → 创建 Pod 验证被挂起 → `kubectl uncordon`
7. `bash teardown.sh` — 清理
