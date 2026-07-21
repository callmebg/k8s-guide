# 实验：CNI 深潜

配套文章：[CNI 深潜](/interview/deep-dive/cni-deep-dive)

## 前置条件

本实验创建 3 节点 Kind 集群（1 control-plane + 2 worker）。

## 步骤

### 1. 创建多节点集群

```bash
bash setup.sh
```

**预期输出：**

```text
NAME                   READY   STATUS    AGE   IP           NODE
cni-test-xxxxx         1/1     Running   10s   10.244.0.5   cni-lab-control-plane
cni-test-yyyyy         1/1     Running   10s   10.244.1.3   cni-lab-worker
cni-test-zzzzz         1/1     Running   10s   10.244.2.3   cni-lab-worker2
```

### 2. 同节点抓包

```bash
# 进入 Kind 节点容器
docker exec -it cni-lab-worker bash

# 在 cni0 bridge 上抓包
tcpdump -i cni0 -n -c 20
```

在另一个终端，从 worker 上的 Pod ping 同节点另一个 Pod：

```bash
POD=$(kubectl get pod -l app=cni-test -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD -- ping 10.244.2.3 -c 3
```

**预期：** tcpdump 显示 ARP + ICMP 经过 cni0 bridge（L2 转发）。

### 3. 跨节点抓包

```bash
# 在 worker 节点抓 VXLAN 流量
docker exec -it cni-lab-worker tcpdump -i vxlan.calico -n -c 10
# 如果没有 VXLAN 接口，抓 eth0 的 encapsulated 流量
docker exec -it cni-lab-worker tcpdump -i eth0 -n -c 10 encap
```

从 worker 上的 Pod ping 另一个 worker 上的 Pod：

```bash
POD=$(kubectl get pod -l app=cni-test -o jsonpath='{.items[0].metadata.name}')
REMOTE_IP=$(kubectl get pod -l app=cni-test -o jsonpath='{.items[2].status.podIP}')
kubectl exec $POD -- ping $REMOTE_IP -c 3
```

**预期：** 如果是 VXLAN，能看到 UDP 8472 端口的封装包。

### 4. 检查 CNI 配置

```bash
docker exec -it cni-lab-worker cat /etc/cni/net.d/*.conf
```

### 5. 检查 iptables 规则数

```bash
docker exec -it cni-lab-worker bash -c "iptables-save | wc -l"
```

### 6. 清理

```bash
bash teardown.sh
```
