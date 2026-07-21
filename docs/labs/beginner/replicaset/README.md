# 实验：ReplicaSet

配套文章：[05. ReplicaSet](/beginner/05-replicaset)

## 步骤

1. `bash setup.sh` — 创建 ReplicaSet（3 副本）
2. `kubectl get replicasets` — 查看 DESIRED/CURRENT/READY
3. `kubectl scale replicaset nginx-rs --replicas=5` — 扩容
4. `kubectl scale replicaset nginx-rs --replicas=1` — 缩容
5. 删一个 Pod 观察自愈：`kubectl delete pod -l app=nginx-rs --field-selector=status.phase=Running`
6. `bash teardown.sh` — 清理
