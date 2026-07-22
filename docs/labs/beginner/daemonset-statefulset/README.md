# 实验：DaemonSet 与 StatefulSet

配套文章：[15. DaemonSet 与 StatefulSet](/beginner/15-daemonset-statefulset)

## 步骤

1. `bash setup.sh` — 部署 DaemonSet + StatefulSet
2. `kubectl get pods -l app=node-agent -o wide` — 观察每个节点一个 DaemonSet Pod
3. `kubectl get pods -l app=web-stateful` — 观察固定命名（web-stateful-0, web-stateful-1）
4. `kubectl get pvc` — 观察每个 StatefulSet Pod 有独立 PVC
5. **验证 Headless DNS**：`kubectl run dns-test --image=busybox --rm -it --restart=Never -- nslookup web-stateful-0.web-stateful-svc`
6. **验证固定身份**：`kubectl delete pod web-stateful-0 && kubectl get pods -l app=web-stateful -w`（Pod 以相同名字重建）
7. `bash teardown.sh` — 清理
