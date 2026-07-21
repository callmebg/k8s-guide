# 实验：Deployment

配套文章：[04. Deployment](/beginner/04-deployment)

## 步骤

### 1. 创建 Deployment

```bash
bash setup.sh
```

**预期输出：**

```text
deployment.apps/nginx-deploy created
deployment "nginx-deploy" successfully rolled out
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   3/3     3            3           5s
```

### 2. 模拟 Pod 故障

```bash
POD=$(kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
kubectl delete pod $POD
kubectl get pods -l app=nginx -w
# 观察：旧 Pod Terminating，新 Pod 自动创建
# Ctrl+C 退出
```

### 3. 扩缩容

```bash
kubectl scale deployment nginx-deploy --replicas=5
kubectl get pods -l app=nginx
kubectl scale deployment nginx-deploy --replicas=2
kubectl get pods -l app=nginx
```

### 4. 滚动更新

```bash
kubectl set image deployment/nginx-deploy nginx=nginx:1.28
kubectl rollout status deployment/nginx-deploy
kubectl rollout history deployment/nginx-deploy
```

### 5. 回滚

```bash
kubectl rollout undo deployment/nginx-deploy
```

### 6. 清理

```bash
bash teardown.sh
```
