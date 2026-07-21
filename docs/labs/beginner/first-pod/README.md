# 实验：第一个 Pod

配套文章：[03. 第一个 Pod](/beginner/03-first-pod)

## 前置条件

运行 `docs/labs/beginner/install-kind/setup.sh` 创建集群。

## 步骤

### 1. 部署 Pod

```bash
bash setup.sh
```

### 2. 查看 Pod 状态

```bash
kubectl get pods
```

**预期输出：**

```text
NAME           READY   STATUS    RESTARTS   AGE
my-first-pod   1/1     Running   0          10s
```

### 3. 查看详细信息

```bash
kubectl describe pod my-first-pod
```

### 4. 端口转发并访问

```bash
kubectl port-forward pod/my-first-pod 8080:80
# 浏览器打开 http://localhost:8080
# Ctrl+C 停止
```

### 5. 查看日志

```bash
kubectl logs my-first-pod
```

### 6. 进入容器

```bash
kubectl exec -it my-first-pod -- /bin/bash
# 在容器内执行
hostname
exit
```

### 7. 清理

```bash
bash teardown.sh
```
