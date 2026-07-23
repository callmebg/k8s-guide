---
track: interview
type: question-bank
domain: storage
title: 存储面试题集
description: K8s 存储高频面试题 — 双层答案（简答 + 深入）
k8sVersion: "v1.31.0"
---

# 存储面试题集

## 基础概念

### Q1: 描述 PV/PVC 的绑定流程

**简答（面试用）：**
PVC 创建后，PV Controller 在集群中查找匹配的 PV（容量、AccessMode、StorageClass 匹配），选择满足需求的最小 PV 进行一对一绑定。如果没有匹配的 PV 且指定了 StorageClass，则触发动态供应。

**深入解释：**
绑定是排他的（一个 PV 只能绑定一个 PVC），绑定后除非删除 PVC 否则不会释放。查找策略是"最小满足"而非"最佳匹配"。动态供应由 StorageClass 的 Provisioner 创建 PV。

→ 详见 [存储深潜 · 第 1 层](../deep-dive/storage-deep-dive)

---

### Q2: AccessMode 有哪些？什么场景选什么？

**简答：**
三种模式：RWO（单节点读写）、ROX（多节点只读）、RWX（多节点读写）。数据库选 RWO，共享配置选 ROX，共享文件系统选 RWX。

**深入解释：**

| AccessMode | 缩写 | 挂载方式 | 典型场景 | 需要支持 |
|-----------|------|---------|---------|---------|
| ReadWriteOnce | RWO | 单节点读写 | 数据库、日志 | 块存储均可 |
| ReadOnlyMany | ROX | 多节点只读 | 静态资源、配置 | NFS/EFS/对象存储 |
| ReadWriteMany | RWX | 多节点读写 | 共享缓存、CMS 上传目录 | NFS/EFS/CephFS |

> ⚠️ RWO 的"Once"是指**单节点**，不是单 Pod —— 同一节点上的多个 Pod 可以共享 RWO 卷。

---

### Q3: hostPath 的局限性是什么？

**简答：**
hostPath 将节点目录挂载到 Pod，Pod 和节点强绑定。节点故障时数据丢失，Pod 无法跨节点迁移。**仅用于测试和开发**。

**深入解释：**
hostPath 的四大缺陷：(1) 无高可用——节点挂了 Pod 和数据一起没了 (2) 跨节点不可访问——Pod 被调度到其他节点时无法访问原有数据 (3) 无生命周期管理——容器删除后数据需要手动清理 (4) 安全隐患——Pod 可访问节点文件系统。生产环境应使用 PV/PVC + StorageClass 替代。

---

### Q4: Reclaim Policy 的 Retain 和 Delete 怎么选？

**简答：**
`Delete` 在删除 PVC 时自动删除 PV 和底层存储（⚠️ 数据丢失），适合 CI/CD 和开发环境。`Retain` 保留存储数据，需管理员手动清理，适合生产环境。

**深入解释：**
Retain 模式删除 PVC 后 PV 变为 Released 状态，管理员需手动：(1) 删除 PV (2) 清理底层存储数据 (3) 重建 PV。这提供了"误删保护"——PVC 误删除不会立即导致数据丢失。

→ 详见 [存储深潜 · 第 2 层](../deep-dive/storage-deep-dive)

---

### Q5: 一块磁盘能同时挂载到多个 Pod 吗？

**简答：**
取决于 AccessMode 和底层存储类型。RWO 模式下块存储（EBS、GCE PD）只能挂到一个节点；RWX 模式下文件存储（NFS、EFS、CephFS）可以挂到多个节点。

**深入解释：**
块存储的底层实现是网络磁盘 Attach 到虚拟机，一个磁盘通常只能 Attach 到一台 VM。NFS/EFS 等文件存储是协议级别的共享（多个客户端挂载同一个 NFS export），天然支持多节点。Ceph RBD 虽然是块存储，但 CephFS 支持多节点。

---

## 进阶问题

### Q6: CSI 的三个 Service 接口分别是什么？

**简答：**
CSI 定义了三组 gRPC Service：(1) Identity — 驱动身份和健康检查 (2) Controller — Volume 生命周期管理 (3) Node — 节点上的 mount/unmount 操作。

**深入解释：**
Controller Service 在控制平面运行（通常是一个 Deployment），负责 CreateVolume/DeleteVolume/ControllerPublishVolume。Node Service 在每个节点运行（DaemonSet），负责 NodeStageVolume（格式化+全局挂载）和 NodePublishVolume（bind mount 到 Pod 目录）。这种分离使存储厂商只需实现 gRPC 接口，不需要修改 K8s 核心代码。

→ 详见 [存储深潜 · 第 3 层](../deep-dive/storage-deep-dive)

---

### Q7: StatefulSet 的 PVC 和 Deployment 的 PVC 有什么不同？

**简答：**
StatefulSet 通过 `volumeClaimTemplates` 为每个 Pod 创建独立 PVC（如 `data-postgres-0`、`data-postgres-1`），Pod 重启/迁移后重新绑定到同一 PVC。Deployment 的 PVC 是所有 Pod 共享的（不适用于有状态应用）。

**深入解释：**
StatefulSet 的 `volumeClaimTemplates` 为每个副本创建一个独立的 PVC，PVC 名称包含 Pod 序号。Pod 重建时（即使调度到不同节点），会重新绑定到同一个 PVC，数据不丢失。这是 StatefulSet 实现"Stable Storage"（稳定存储标识）的机制。Deployment 的所有副本共享同一个 PVC template → 共享同一个 PV（需要 RWX 模式）。

---

### Q8: 什么是卷快照（VolumeSnapshot）？和备份有什么区别？

**简答：**
卷快照是 PV 在某一时刻的**即时复制**（通常秒级完成，基于存储层的 COW），用于快速恢复。备份是数据的**独立副本**，通常存储在不同位置，恢复时间更长但更安全。

**深入解释：**

| 维度 | VolumeSnapshot | 传统备份 |
|------|---------------|---------|
| 速度 | 秒~分钟级（COW） | 分钟~小时级 |
| 存储位置 | 同存储系统 | 异地/其他存储 |
| 恢复速度 | 快速（克隆快照） | 慢（传输+恢复） |
| 灾难恢复 | ❌ 依赖原存储可用 | ✅ 异地恢复 |
| 成本 | 低（仅存增量） | 高（全量存储） |

**最佳实践**：快照用于快速恢复（RPO 分钟级），备份用于灾难恢复（RPO 小时级/天级）。两者互补，不是互斥。

---

### Q9: PVC 扩容的限制条件是什么？

**简答：**
需要 StorageClass 设置 `allowVolumeExpansion: true`，且底层 CSI 驱动支持扩容。部分驱动支持在线扩容（不重启 Pod），部分需要重启。

**深入解释：**
扩容流程：(1) 修改 PVC `spec.resources.requests.storage` (2) Provisioner 调用 CSI ControllerExpandVolume (3) kubelet 调用 CSI NodeExpandVolume 扩容文件系统 (4) 如果驱动不支持在线扩容，会在 Conditions 中标记 `FileSystemResizePending`，Pod 重启后生效。注意：**只能扩容不能缩容**。

---

### Q10: 拓扑感知卷调度解决什么问题？

**简答：**
解决块存储（EBS/GCE PD）只能在特定 Zone 使用的问题——确保 PV 创建在 Pod 被调度的 Zone 内，避免跨 Zone 挂载失败。

**深入解释：**
AWS EBS 卷被限制在创建时的可用区。如果 PV 在 `us-east-1a` 创建、Pod 被调度到 `us-east-1b` → 挂载失败。`volumeBindingMode: WaitForFirstConsumer` 延迟 PV 创建，等 Pod 调度完成后再在 Pod 所在 Zone 创建 PV。CSI 驱动通过 `topologyKeys` 声明支持的可用区。

---

### Q11: emptydir 和 hostPath 的区别？

**简答：**
emptyDir 的生命周期与 Pod 绑定（Pod 删除 = 数据删除），数据在节点本地临时存储。hostPath 的生命周期与 Node 绑定（Pod 删除数据仍在节点上）。emptyDir 更安全（Pod 删除自动清理），hostPath 适合需要持久化到节点的场景。

**深入解释：**
emptyDir 可以配置 `medium: Memory` 使用 tmpfs（内存文件系统，速度快但容量受限于节点内存）。hostPath 有安全风险（Pod 可读写节点文件系统），需要 PodSecurityPolicy/PSA 控制。

---

### Q12: 生产环境中本地存储 vs 网络存储怎么选择？

**简答：**
性能敏感场景（数据库）用本地 SSD 或云厂商块存储（低延迟）；多节点共享场景用 NFS/EFS/CephFS（高可用）；开发测试用 hostPath 或 local-path provisioner。

**深入解释：**
本地 NVMe SSD 延迟 < 100μs，网络存储延迟 1-10ms。但本地存储无法跨节点——选择本地存储时需接受"节点故障 = 数据不可用"（除非有应用层复制）。云厂商块存储（EBS gp3、GCE PD-SSD）在延迟和可用性之间做了折中（通过多副本和快照实现数据保护）。
