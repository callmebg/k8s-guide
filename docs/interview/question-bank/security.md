---
track: interview
type: question-bank
domain: security
title: 安全面试题集
description: K8s 安全高频面试题 — 双层答案（简答 + 深入）
k8sVersion: "v1.31.0"
---

# 安全面试题集

## 基础概念

### Q1: K8s 的认证和鉴权有什么区别？

**简答（面试用）：**
认证（Authentication）回答"你是谁"，鉴权（Authorization）回答"你能做什么"。两者在 apiserver 的三段处理链中是不同阶段。

**深入解释：**
认证方式包括 X.509 证书、Bearer Token、OIDC 等。鉴权方式包括 RBAC、Node Authorizer、Webhook。apiserver 先做认证确认身份，再做鉴权检查权限，最后通过准入控制（Admission）做最后的校验/修改。

→ 详见 [安全深潜 · 第 1 层](../deep-dive/security-deep-dive)

---

### Q2: ServiceAccount 和 User 有什么区别？

**简答：**
ServiceAccount 是 K8s 管理的身份（Pod 使用），User 是外部实体（人/外部系统）。SA 在集群内创建和管理，User 由外部身份系统管理。

**深入解释：**
SA 有对应的 Secret（Token）自动挂载到 Pod，用于 Pod 与 apiserver 通信。User 没有 K8s 资源对象，由认证模块识别（如证书的 CN 字段）。权限控制都是通过 RBAC 绑定。

---

### Q3: Role 和 ClusterRole 的区别？

**简答：**
Role 是命名空间级别的权限（只在本 ns 有效），ClusterRole 是集群级别的权限（跨所有 ns 或集群级资源）。

**深入解释：**
ClusterRole 可以定义两类权限：(1) 集群级资源（Node、PV、Namespace）(2) 所有命名空间的普通资源。ClusterRole 可以通过 RoleBinding 绑定到特定命名空间，实现"集群范围定义 + 命名空间使用"的模式。

→ 详见 [安全深潜 · 第 1 层](../deep-dive/security-deep-dive)

---

### Q4: Pod Security Standards 解决了什么问题？

**简答：**
PSS 定义了三个安全级别（Privileged/Baseline/Restricted）来约束 Pod 的安全配置，防止容器以特权模式运行、使用 hostNetwork 等危险操作。

**深入解释：**
PSS 替代了已弃用的 PodSecurityPolicy。通过命名空间标签 `pod-security.kubernetes.io/enforce` 设置强制级别。关键限制包括：禁止特权容器、禁止 hostPath、强制 runAsNonRoot、限制 capabilities。三个模式（enforce/warn/audit）支持渐进迁移。

→ 详见 [安全深潜 · 第 2 层](../deep-dive/security-deep-dive)

---

### Q5: 什么是 etcd 静态加密？为什么需要？

**简答：**
etcd 存储所有 K8s 数据包括 Secret，默认不加密。静态加密用 AES-CBC 在写入 etcd 前加密数据，防止备份泄露或磁盘被盗导致 Secret 泄露。

**深入解释：**
配置后新的 Secret 写入时自动加密。但已有 Secret 不会自动重新加密——需要手动执行 `kubectl get secrets --all-namespaces -o json | kubectl replace -f -` 触发重写。加密密钥建议存储在外部 KMS 中。

---

## 进阶问题

### Q6: RBAC 的"最小权限原则"怎么落地？

**简答：**
为每个角色只授予完成任务所需的**最少权限**。用命名空间隔离团队、用 Role 限制资源范围、用具体 verb 限制操作类型。定期审计并回收不需要的权限。

**深入解释：**
落地步骤：(1) 每个团队独立 Namespace (2) 为每个应用创建独立 ServiceAccount (3) 用 Role + RoleBinding 授予 SA 所需权限 (4) 避免使用 cluster-admin (5) 使用 `kubectl auth can-i --as <user> --list` 验证实际权限 (6) 定期运行 `kubectl-who-can` 或类似工具审计。

---

### Q7: 准入控制器（Admission Controller）做什么？

**简答：**
准入控制器是 apiserver 在写入 etcd 前的最后一关。Mutating Webhook 可以**修改**请求（注入 Sidecar、设置默认值），Validating Webhook 可以**拒绝**不合规请求。

**深入解释：**
执行顺序：Mutating → Validating。常用场景：(1) 注入 Istio Sidecar（Mutating）(2) 检查镜像来源是否可信（Validating）(3) 强制所有 Pod 设置 Resource limits（Validating）(4) 自动添加 toleration（Mutating）。工具：OPA/Gatekeeper（Rego 策略）、Kyverno（K8s 原生策略）。

---

### Q8: NetworkPolicy 的 default-deny 是什么意思？

**简答：**
创建一个"拒绝所有入口流量"的 NetworkPolicy，然后按需为每个服务创建"允许"规则（白名单模式）。默认没有 NetworkPolicy 时，所有 Pod 可以互相通信。

**深入解释：**
默认行为：没有 NetworkPolicy → 所有流量允许。default-deny 策略：
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
spec:
  podSelector: {}  # 选中所有 Pod
  policyTypes: ["Ingress", "Egress"]
```
之后每条流量都需要显式的 allow 规则。这是零信任网络模型的实践基础。

---

### Q9: 镜像扫描工具怎么集成到 K8s 部署流程？

**简答：**
在 CI 阶段扫描镜像（Trivy/Grype），设置阻断阈值（如 severity ≥ HIGH），通过准入控制器在部署时验证（cosign 签名 + 扫描报告）。

**深入解释：**
三步集成：(1) CI 阶段 `trivy image --exit-code 1 --severity HIGH,CRITICAL my-image` 阻断有高危漏洞的镜像 (2) 构建后 `cosign sign` 签名 (3) 准入控制器在部署时 `cosign verify` 验证签名。即使 CI 被绕过，准入控制也能拦截未签名镜像。

---

### Q10: K8s Secret 的安全最佳实践？

**简答：**
(1) 不要硬编码到代码 (2) 不要在 Git 中提交明文的 Secret YAML (3) 使用 external-secrets-operator 或 Vault 注入 (4) 启用 etcd 加密 (5) 审计所有 Secret 访问 (6) 使用 RBAC 限制 Secret 读取权限。

**深入解释：**
Secret 只是 Base64 编码，不是加密。`external-secrets-operator` 将 Secret 存储在外部（AWS Secrets Manager/HashiCorp Vault/GCP Secret Manager），通过 CRD 同步到 K8s Secret。SOP 攻击（通过 CI 窃取 Secret）是最常见的泄露方式 → 使用 Sealed Secrets 或 SOPS 加密提交 Secret 到 Git。

---

### Q11: 审计日志怎么配置？应该审计什么？

**简答：**
通过 `--audit-policy-file` 配置审计策略。至少记录：Secret 访问（RequestResponse）、RBAC 修改、命名空间创建/删除、Pod exec 操作、Deployment 修改。

**深入解释：**
审计策略四个级别：
- None：不记录
- Metadata：记录谁在什么时间做了什么（不含请求体和响应体）
- Request：记录元数据 + 请求体
- RequestResponse：记录完整的请求和响应（⚠️ 包含 Secret 内容）

生产环境建议：Metadata 级别记录所有 API 调用，RequestResponse 级别仅用于 Secret 相关的调试和合规审计。

---

### Q12: 如何防止容器逃逸？

**简答：**
多层防御：(1) runAsNonRoot + drop ALL capabilities (2) seccomp RuntimeDefault (3) readOnlyRootFilesystem (4) 禁止 privileged 容器 (5) 使用 restricted PSS (6) 保持容器运行时和内核的补丁更新。

**深入解释：**
常见逃逸路径和防御：
- 特权容器 `privileged: true` → 用 PSA restricted 禁止
- 挂载 Docker Socket → 用准入控制器禁止 `hostPath` 挂载 `/var/run/docker.sock`
- CVE 漏洞（如 runc CVE-2019-5736）→ 保持运行时版本更新
- Capabilities 提权 → `drop: ["ALL"]`，仅 `add` 必要能力
- `nsenter` 切换命名空间 → seccomp 过滤 `setns` 系统调用

### Q13: OPA/Gatekeeper 和 Kyverno 选哪个？

**简答：**
OPA/Gatekeeper 使用 Rego 语言编写策略（功能强大但学习曲线高），Kyverno 使用 K8s 原生 YAML 语法编写策略（简单直观但灵活性稍弱）。小团队选 Kyverno，大企业选 OPA。

**深入解释：**

| 维度 | OPA/Gatekeeper | Kyverno |
|------|---------------|---------|
| 策略语言 | Rego（类 Prolog） | K8s 原生 YAML |
| 学习曲线 | 陡峭 | 平缓 |
| 表达能力 | 极强（任意逻辑） | 中等 |
| 生态 | CNCF 毕业项目 | 快速增长 |
| 镜像验证 | ✅ | ✅ |
| 自动修正 | 需配合其他工具 | 内置 generate 功能 |
| 性能 | 优秀 | 良好 |
