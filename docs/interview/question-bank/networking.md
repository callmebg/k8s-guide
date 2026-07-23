---
track: interview
type: question-bank
domain: networking
title: 网络面试题集
description: K8s 网络高频面试题 — 双层答案（简答 + 深入）
k8sVersion: "v1.31.0"
---

# 网络面试题集

## 基础概念

### Q1: 什么是 CNI？它在 K8s 中扮演什么角色？

**简答（面试用）：**
CNI（Container Network Interface）是容器网络的标准接口规范。K8s 通过 CNI 插件为 Pod 分配 IP 并实现 Pod 间通信。kubelet 在创建 Pod 时通过 CRI 调用 CNI 插件的 ADD 方法来配置网络。

**深入解释：**
CNI 定义了三个核心操作：ADD（创建网络）、DEL（清理网络）、CHECK（健康检查）。Pod 创建时，kubelet → CRI → CRI runtime → CNI 插件，CNI 插件创建 veth pair、配置 bridge、通过 IPAM 分配 IP。

→ 详见 [CNI 深潜 · 第 1 层](../deep-dive/cni-deep-dive)

---

### Q2: Service 的 ClusterIP 是怎么实现的？

**简答：**
ClusterIP 由 Service controller 分配，kube-proxy 负责实现流量转发。kube-proxy 在每个节点上监听 Service 和 Endpoint 变化，生成 iptables（或 IPVS）规则，将访问 ClusterIP 的流量 DNAT 到后端 Pod IP。

**深入解释：**
iptables 模式下，kube-proxy 为每个 Service 生成 DNAT 规则，数据包命中规则后目标 IP 被替换为某个后端 Pod IP（随机选择）。IPVS 模式下，规则存储在内核的 IPVS 模块中，使用哈希表 O(1) 查找，支持多种负载均衡算法。

---

### Q3: Flannel 和 Calico 的核心区别？

**简答：**
Flannel 使用 VXLAN overlay 封装跨节点通信，简单但不支持 NetworkPolicy。Calico 使用 BGP routing（无封装）或 iptables，支持 NetworkPolicy，性能更好。

**深入解释：**

| 维度 | Flannel | Calico |
|------|---------|--------|
| Datapath | VXLAN overlay | BGP routing / iptables |
| 封装 | 有（50B header） | BGP 无封装 |
| NetworkPolicy | 不支持 | 支持 |
| 大规模 | 性能下降 | 更稳定 |
| 复杂度 | 低 | 中 |

→ 详见 [CNI 深潜 · 第 3 层](../deep-dive/cni-deep-dive)

---

### Q4: kube-proxy 的 iptables 和 IPVS 模式有什么区别？

**简答：**
iptables 模式用链式规则顺序匹配（O(n)），Service 多时性能下降。IPVS 模式用内核哈希表（O(1)），支持轮询/最少连接等多种负载均衡算法，适合大规模集群。

**深入解释：**
iptables 模式：每个 Service 对应一条 DNAT 规则，数据包需要顺序遍历所有规则。1000 个 Service 意味着 1000 次匹配。IPVS 模式：Service 映射到 IPVS 内核对象，数据包通过哈希直接定位，时间复杂度恒定。

---

### Q5: eBPF 在 K8s 网络中有什么优势？

**简答：**
eBPF 允许在内核中运行沙箱程序，Cilium 用它替代 iptables 做 datapath 和 NetworkPolicy enforcement，实现 O(1) 的包处理性能，并提供强大的网络可观测性（Hubble）。

**深入解释：**
eBPF 程序挂载在 tc（Traffic Control）或 XDP（eXpress Data Path）层。XDP 在网卡驱动层处理数据包，比 tc 更早、更快。NetworkPolicy 被编译为 eBPF map（哈希表），查表 O(1)，不受规则数影响。Hubble 利用 eBPF 采集流量元数据，提供实时可视化。

→ 详见 [CNI 深潜 · 第 3 层](../deep-dive/cni-deep-dive)

---

## 进阶场景

### Q6: Pod 间通信延迟高怎么排查？

**简答：**
分层排查：确认同节点还是跨节点 → 检查 CNI 封装方式 → 检查 iptables 规则数 → 检查 conntrack 表。

**深入解释：**
排查步骤：

1. `kubectl exec pod-a -- ping pod-b` 确认延迟是同节点还是跨节点
2. 同节点：`tcpdump -i cni0` 查看 bridge 转发
3. 跨节点：检查是否 VXLAN 封装（额外 50B header + 封装/解封装开销）
4. `iptables-save | wc -l` 检查规则数（超过 1 万条可能有问题）
5. `conntrack -C` 检查 conntrack 表使用率（满了会丢包）
6. `kubectl get hubble` 如果用了 Cilium，Hubble 能直接看到延迟分布

---

### Q7: 大规模集群（500+ 节点）的网络瓶颈在哪？

**简答：**
两个主要瓶颈：kube-proxy 的 Service 规则（用 IPVS 解决）和 NetworkPolicy 规则数（用 eBPF 解决）。

**深入解释：**

| 瓶颈 | 原因 | 解决方案 |
|------|------|----------|
| kube-proxy iptables | O(n) 规则遍历 | 切换 IPVS 模式 |
| NetworkPolicy iptables | O(policies × pods) 规则数 | Cilium eBPF（O(1) map 查表） |
| conntrack 表溢出 | 连接数超过 nf_conntrack_max | 增大 `net.netfilter.nf_conntrack_max` |
| DNS 查询延迟 | CoreDNS 单点瓶颈 | NodeLocal DNS Cache |

---

### Q8: NetworkPolicy 的执行靠什么？iptables 和 eBPF 实现有什么差异？

**简答：**
NetworkPolicy 由 CNI 插件执行。Calico 用 iptables 规则（O(n) 遍历），Cilium 用 eBPF map（O(1) 查表）。大规模下 eBPF 性能更稳定。

**深入解释：**
Calico 的 iptables 方式：每条 Policy 生成一组 iptables 规则，规则数随 Pod 和 Policy 数量线性增长。1000 Pod × 100 Policy = 10 万条规则，iptables 更新需要秒级时间。Cilium 的 eBPF 方式：Policy 编译为 eBPF map 条目，更新是原子操作 O(1)，包处理时 O(1) 查表。

→ 详见 [CNI 深潜 · 第 4 层](../deep-dive/cni-deep-dive)

---

### Q9: 什么是 Ingress Controller？它和 Service 的 LoadBalancer 有什么区别？

**简答：**
Ingress Controller 是 L7 层的 HTTP 路由器，根据域名和 URL 路径转发到不同 Service。LoadBalancer 是 L4 层的 TCP/UDP 负载均衡，一个 LB 只对应一个 Service。

**深入解释：**

| 维度 | Ingress Controller | LoadBalancer Service |
|------|-------------------|---------------------|
| 层级 | L7（HTTP/HTTPS） | L4（TCP/UDP） |
| 路由能力 | 域名/路径/TLS 终止 | 无路由，单一转发 |
| 外部 IP | 共享一个 IP | 每个 Service 一个 IP |
| 成本 | 低（共享入口） | 高（每个 LB 计费） |
| 典型实现 | Nginx/Traefik | 云厂商 LB |

---

### Q10: 怎么设计一个多租户 K8s 集群的网络隔离方案？

**简答：**
三层隔离：Namespace 做逻辑隔离 + NetworkPolicy 做流量隔离 + 可选 Service Mesh 做 mTLS 加密通信。

**深入解释：**
设计方案：

1. **Namespace 隔离**：每个租户一个 Namespace，配合 RBAC 限制操作权限
2. **NetworkPolicy**：默认 deny-all，只允许租户内 Pod 互相访问和必要的出口流量
3. **ResourceQuota**：限制每个租户的资源使用上限
4. **可选：Cilium** 的 GlobalNetworkPolicy 统一管理跨 Namespace 策略
5. **可选：Istio** 的 mTLS 确保租户间即使有流量也是加密的
6. **DNS 隔离**：CoreDNS 的 policy 插件限制跨 Namespace DNS 查询

---

## 场景设计题

### 场景：公司有开发/测试/生产三个 K8s 集群，如何设计网络方案？

**关键考量：**

1. **CNI 选型**：开发/测试用 Flannel（简单），生产用 Cilium（性能+可观测性）
2. **跨集群通信**：Submariner 或 Cilium Cluster Mesh
3. **统一策略管理**：Cilium GlobalNetworkPolicy 或 OPA/Gatekeeper
4. **IP 地址规划**：每个集群不同 Pod CIDR（如 10.0.0.0/16, 10.1.0.0/16, 10.2.0.0/16）
5. **DNS 跨集群**：CoreDNS forward 插件或 Submariner Lighthouse

**参考架构：**

```text
┌─ 开发集群 (Flannel, 10.0.0.0/16) ─┐
│                                     │── Submariner ──┐
└─────────────────────────────────────┘                │
┌─ 测试集群 (Calico, 10.1.0.0/16) ──┐                  │
│                                     │── Submariner ──┤
└─────────────────────────────────────┘                │
┌─ 生产集群 (Cilium, 10.2.0.0/16) ──┐                  │
│  + Hubble 可观测                    │── Submariner ──┘
│  + GlobalNetworkPolicy              │
└─────────────────────────────────────┘
```
