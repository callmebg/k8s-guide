# 实验：存储基础

配套文章：[10. 存储基础](/beginner/10-storage-basics)

## 步骤

1. `bash setup.sh` — 创建 PVC + Pod
2. `kubectl get pvc` — 查看 PVC 状态（应为 Bound）
3. 验证数据：`kubectl exec pvc-pod -- cat /data/test.txt`（预期：Hello K8s Storage!）
4. 删除 Pod：`kubectl delete pod pvc-pod`
5. 重新创建：`kubectl apply -f manifests/pvc-pod.yaml`
6. 再次验证数据仍在：`kubectl exec pvc-pod -- cat /data/test.txt`
7. `bash teardown.sh` — 清理
