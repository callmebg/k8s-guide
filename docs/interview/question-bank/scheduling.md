---
track: interview
type: question-bank
domain: scheduling
title: 调度面试题集
description: K8s 调度高频面试题 — 双层答案（简答 + 深入）
k8sVersion: "v1.31.0"
---

# 调度面试题集

## 基础概念

### Q1: K8s 调度器的核心工作流程是什么？

**简答（面试用）：**
调度器通过 Filtering（过滤掉不满足条件的节点）和 Scoring（给剩余节点打分）两步决定 Pod 的最终位置。

**深入解释：**
Scheduling Cycle 是串行的：Sort → PreFilter → Filter → PostFilter → PreScore → Score → NormalizeScore → Reserve → Permit。Filtering 淘汰不满足硬约束的节点（资源不足、污点不匹配、亲和性不满足），Scoring 给每个剩余节点打分，选最高分。Binding Cycle 异步执行绑定操作。

→ 详见 [调度深潜 · 第 1 层](../deep-dive/scheduling-deep-dive)

---

### Q2: Taint/Toleration 和 Node Affinity 的核心区别？

**简答：**
Taint/Toleration 是**排斥机制**（节点说"不匹配就走"），Node Affinity 是**吸引机制**（Pod 说"我想去那里"）。两者解决不同方向的问题。

**深入解释：**
Taint 标在 Node 上（key=value:Effect），Pod 需要匹配的 Toleration 才能调度到该节点。Node Affinity 标在 Pod spec 中，选择具有特定 label 的节点。生产中的典型组合：GPU 节点打 `dedicated=gpu:NoSchedule` 排斥普通 Pod，GPU Pod 使用 Node Affinity 和 Toleration 精确匹配到这些节点。

→ 详见 [调度深潜 · 第 2 层](../deep-dive/scheduling-deep-dive)

---

### Q3: `requiredDuringScheduling` 和 `preferredDuringScheduling` 的区别？

**简答：**
`required` 是**硬约束**（不满足就不调度），`preferred` 是**软约束**（尽量满足，不满足也能调度），通过 Scoring 权重体现。

**深入解释：**
硬约束在 Filter 阶段检查，不满足直接淘汰节点。软约束在 Score 阶段参与打分，值为 1-100 的权重，调度器在没有满足所有软约束的节点时仍会选择得分最高的节点。

---

### Q4: 调度器怎么处理 Pod 优先级？

**简答：**
当高优先级 Pod 无法调度时，调度器进入 PostFilter 阶段寻找可抢占的低优先级 Pod，驱逐它们后释放资源给高优先级 Pod。

**深入解释：**
优先级由 PriorityClass 资源定义，值越大优先级越高（最高 10^9）。抢占流程：(1) 调度器确认所有候选节点都无法满足高优先级 Pod (2) 在每个节点上计算需要驱逐哪些低优先级 Pod (3) 选择"影响最小"的节点执行抢占 (4) 被驱逐的 Pod 优雅终止后重新入队。

→ 详见 [调度深潜 · 第 4 层](../deep-dive/scheduling-deep-dive)

---

### Q5: 调度队列中的 Pod 是怎么管理的？

**简答：**
调度器维护三级队列：ActiveQ（当前等待调度）、BackoffQ（调度失败后退避等待）、UnschedulableQ（确认不可调度，等待集群变化）。

**深入解释：**
新 Pod 进入 ActiveQ，调度失败后根据失败原因进入 BackoffQ（指数退避 1s→2s→4s→…→10s）或 UnschedulableQ（资源不足等结构性原因）。集群状态变化（新增节点、Pod 删除）时，UnschedulableQ 中的 Pod 重新进入 ActiveQ。

→ 详见 [调度深潜 · 第 1 层](../deep-dive/scheduling-deep-dive)

---

## 进阶问题

### Q6: TopologySpreadConstraints 和 PodAntiAffinity 怎么选？

**简答：**
TopologySpreadConstraints 在**域级别**（Zone/Region/Host）控制均匀度，PodAntiAffinity 在**Pod 级别**控制互斥。前者适合"跨 Zone 均匀分布"场景，后者适合"每个节点最多一个"场景。

**深入解释：**

| 维度 | TopologySpreadConstraints | PodAntiAffinity |
|------|--------------------------|-----------------|
| 粒度 | 域级（Zone/Region） | Pod 级 |
| 控制方式 | maxSkew（最大偏差） | 互斥/倾向 |
| 典型场景 | 跨可用区高可用 | 每个节点一个副本 |
| 性能开销 | 低（只比较计数） | 高（遍历域内所有 Pod） |
| 需要 labelSelector | 是 | 是 |
| 是否可软约束 | 是（ScheduleAnyway） | 是（preferred） |

---

### Q7: 什么会导致 Pod 一直 Pending？

**简答（调度视角）：**
常见原因：(1) 资源不足（CPU/内存/GPU）(2) 污点未容忍 (3) 亲和性规则无法满足 (4) PVC 未绑定 (5) 拓扑分布约束太严格 (6) 节点 Selector 不匹配。

**深入解释：**
排查命令链：
```bash
# 1. 看调度失败原因
kubectl describe pod <pod> | grep -A10 Events

# 2. 检查节点状态
kubectl get nodes -o wide

# 3. 检查 PVC 绑定状态
kubectl get pvc

# 4. 模拟调度器视角
kubectl get events --field-selector reason=FailedScheduling \
  --sort-by='.lastTimestamp' | tail -5
```

---

### Q8: 什么是"调度器过载"？如何缓解？

**简答：**
当集群节点数很大（1000+）且 Pod 创建频率高时，调度器遍历所有节点的成本过高，导致调度延迟增加。

**深入解释：**
缓解方案：(1) 设置 `percentageOfNodesToScore` 限制打分节点数（如 50%），减少 CPU 开销 (2) 使用 Node Affinity 缩小候选节点范围 (3) 部署多个调度器分担负载 (4) 升级到较新版本（1.23+ 调度器有显著性能优化）。

---

### Q9: Descheduler 是什么？为什么需要它？

**简答：**
Descheduler 是调度器的"逆向工具"——它不是调度新 Pod，而是**驱逐已经运行但位置不理想的 Pod**，让调度器重新为它们选最优位置。

**深入解释：**
调度器只在 Pod 创建时决定位置。集群运行一段时间后：(1) 节点资源碎片化 (2) 新增节点上没 Pod (3) 亲和性规则因集群变化而失效。Descheduler 的策略包括 RemoveDuplicates（驱逐同节点副本）、LowNodeUtilization（从高负载节点迁移）、RemovePodsViolatingTopologySpread（修复分布不均）。

---

### Q10: Gang Scheduling 解决什么问题？

**简答：**
Gang Scheduling 解决**批量作业的"all-or-nothing"调度问题**——Job 的所有 Pod 要么同时启动，要么一个都不启动，避免部分 Pod 占着资源等待队友造成的死锁。

**深入解释：**
典型场景：AI 训练作业需要 8 个 GPU Pod 同时运行才能开始。默认调度器可能调度了 5 个 Pod 后剩余 3 个资源不够 → 前 5 个占用资源无法释放，后 3 个永远等不到 → 死锁。Gang Scheduling 通过 PodGroup 概念确保"凑齐了再发车"。Volcano 和 Coscheduling 是主要实现方案。

---

### Q11: 调度框架的扩展点有哪些？各自解决什么问题？

**简答：**
调度框架提供 10+ 个扩展点允许自定义插件注入逻辑，覆盖从排队到绑定的全流程。

**深入解释：**

| 扩展点 | 阶段 | 作用 |
|--------|------|------|
| Sort | 排队 | 排序调度队列中的 Pod |
| PreFilter | 过滤 | 预处理 Pod 信息，计算过滤所需的中间状态 |
| Filter | 过滤 | 淘汰不满足硬约束的节点 |
| PostFilter | 过滤失败 | 无可调度节点时的处理（如抢占） |
| PreScore | 打分 | 打分前预计算 |
| Score | 打分 | 对每个节点打分 |
| Reserve | 预留 | 将资源"预定"给 Pod |
| Permit | 等待 | 延迟/拒绝绑定（如 Gang Scheduling） |
| PreBind | 绑定前 | 绑定前执行 Volume 相关操作 |

---

### Q12: 生产集群中如何避免"调度热点"？

**简答：**
综合使用多种机制：(1) PodAntiAffinity 分散相同应用副本 (2) TopologySpreadConstraints 跨 Zone 均匀分布 (3) 资源配额限制单命名空间的资源使用 (4) Descheduler 定期修复不均衡 (5) 适当的资源 Request 设置（过大导致装箱率低，过小导致资源争抢）。

#### Scenario: 3-Zone 集群部署高可用应用

- **WHEN** 部署一个需要跨 3 个 Zone 高可用的 6 副本 Deployment
- **THEN** 建议配置 TopologySpreadConstraints（maxSkew=1, topologyKey=topology.kubernetes.io/zone）+ PDB（minAvailable=4）+ PodAntiAffinity（preferred, hostname-level）
