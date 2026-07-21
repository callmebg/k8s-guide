# 实验：安装 Kind

配套文章：[02. 安装 Kind](/beginner/02-install-kind)

## 前置条件

- Docker Desktop 已安装并运行
- kubectl 已安装
- Kind 已安装

## 步骤

### 1. 创建集群

```bash
bash setup.sh
```

**预期输出：**

```text
🚀 创建 Kind 集群: k8s-guide-lab
Creating cluster "k8s-guide-lab" ...
 ✓ Ensuring node image (kindest/node:v1.31.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
✅ 集群创建成功
```

### 2. 验证集群

```bash
kubectl get nodes
```

**预期输出：**

```text
NAME                           STATUS   ROLES           AGE   VERSION
k8s-guide-lab-control-plane    Ready    control-plane   30s   v1.31.0
```

### 3. 清理

```bash
bash teardown.sh
```
