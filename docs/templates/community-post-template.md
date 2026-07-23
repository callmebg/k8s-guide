# 社区分发模板

将 K8s Guide 文章发布到中文技术社区时使用此模板。复用时修改标题、摘要、标签。

---

## 掘金（juejin.cn）

### 标题

```
[文章原标题] | K8s Guide 系列
```

示例：`Kubernetes 调度器深度解析 | K8s Guide 系列`

### 摘要（200 字以内）

```
📖 本文出自 [K8s Guide](https://k8s-guide.vercel.app) 开源项目，一个从入门到面试的一站式 Kubernetes 中文学习指南。

本文核心内容：[1-2 句话概括]。

你将学到：
- [要点 1]
- [要点 2]
- [要点 3]

📂 原文地址：https://k8s-guide.vercel.app/<path>
🐙 GitHub：https://github.com/callmebg/k8s-guide
```

### 标签

```
Kubernetes, K8s, 云原生, Docker, [领域标签]
```

领域标签映射：
- 网络 → `CNI`, `Service Mesh`
- 调度 → `调度器`, `资源管理`
- 存储 → `CSI`, `持久化存储`
- 安全 → `容器安全`, `RBAC`

### 封面图

- 尺寸：1080 × 540px（掘金摘要卡）
- 可从项目 `docs/public/og-image.png` 裁剪/衍生
- 技术风格：蓝色系科技感，扁平化设计

### 正文格式

- 掘金支持 markdown，但不支持 mermaid 图表 → 需将 mermaid 转成静态图片（用 mermaid.live 导出）
- 代码块标注语言：` ```yaml `、` ```bash `
- 掘金不支持 `> [!NOTE]` GFM 警告语法 → 改用 blockquote `> ⚠️ 注意`

---

## 知乎（zhihu.com）

### 标题

```
[文章原标题] — K8s 中文学习指南
```

### 开头引导语

```
本文是 [K8s Guide](https://k8s-guide.vercel.app) 系列的第 [N] 篇。K8s Guide 是一个开源的一站式 Kubernetes 学习指南，包含 30+ 篇初学者文章、面试深潜专题和手把手实验。项目地址：github.com/callmebg/k8s-guide

---
```

### 结尾署名

```
---
📖 本文出自 [K8s Guide](https://k8s-guide.vercel.app) — Kubernetes 中文学习指南
🐙 GitHub：[github.com/callmebg/k8s-guide](https://github.com/callmebg/k8s-guide)
⭐ 如果对你有帮助，请给项目一个 Star！
```

### 格式注意事项

- 知乎**不支持 mermaid** → 所有流程图需转为静态图片
- 知乎**不支持 Markdown 表格内部换行和复杂格式** → 简化表格
- 代码块建议使用知乎的"代码块"功能单独发布
- 知乎文章编辑器的 markdown 支持有限 → 推荐分段粘贴 + 手动调整
- 文章发布后添加至专栏（如有）

---

## CSDN（csdn.net）

### 标题格式

```
K8s Guide 系列：[文章原标题]
```

### 分类

选择 `云原生` → `Kubernetes`

### 标签

```
Kubernetes, K8s, 云原生, 容器编排
```

---

## 通用写作建议

1. **前 3 段定生死**：第一段说清楚这篇文章解决什么问题，给读者一个看下去的理由
2. **代码块带解释**：每段代码后跟着"这段代码做了什么"的说明
3. **emoji 适度使用**：掘金和知乎的 emoji 渲染效果不错，但不要每行都加
4. **互动引导**：结尾加"你在实际项目中遇到过这个问题吗？欢迎留言讨论"之类的话
5. **交叉链接**：在文章中自然引用 K8s Guide 中的其他相关文章

---

> 模板版本: v1.0 | 最后更新: 2026-07-23
