# K8s Guide — Kubernetes 中文学习指南

> 从入门到面试的一站式 K8s 学习指南

[![Build Status](https://github.com/callmebg/k8s-guide/actions/workflows/ci.yml/badge.svg)](https://github.com/callmebg/k8s-guide/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 🎯 项目目标

中文社区缺少一份像 JavaGuide 那样系统、免费、开源的 K8s 学习指南。K8s Guide 旨在填补这一空白，为两类受众提供完整的学习路径：

## 🌱 初学者轨道

**适合**：零基础或刚入门 K8s 的用户

- 30 篇线性序列教程，从什么是 K8s 到网络/存储基础
- 每篇文章配套 Kind 实验脚本，本地一键运行
- 生活化比喻 + 详细步骤 + 预期输出

[开始学习 →](https://k8s-guide.vercel.app/beginner/01-what-is-k8s)

## 💼 求职者轨道

**适合**：准备 K8s 相关岗位面试的用户

- **T 型知识结构**：系统全景图 + 各领域广度速览 + 一个领域的深度打穿
- 面试题库：高频题 + 场景设计题 + 双层答案（简答 + 深入）
- 面试策略：简历项目包装、面试流程、岗位分析

[进入面试轨道 →](https://k8s-guide.vercel.app/interview/system-overview)

## 🗺️ 内容进度

### 初学者轨道
| # | 文章 | 实验 | 状态 |
|---|------|------|------|
| 01 | 什么是 Kubernetes | — | 🚧 |
| 02 | 安装 Kind | 🧪 | 🚧 |
| 03 | 第一个 Pod | 🧪 | 🚧 |
| 04 | Deployment | 🧪 | 🚧 |
| 05 | ReplicaSet | 🧪 | 🚧 |
| 06 | Service | 🧪 | 🚧 |
| 07 | ConfigMap 与 Secret | 🧪 | 🚧 |
| 08 | 扩缩容与发布 | 🧪 | 🚧 |
| 09 | 网络基础 | 🧪 | 🚧 |
| 10 | 存储基础 | 🧪 | 🚧 |

### 求职者轨道
| 类型 | 文章 | 状态 |
|------|------|------|
| 系统全景 | K8s 系统全景图 | 🚧 |
| 广度速览 | 网络概念速览 | 🚧 |
| 广度速览 | 调度概念速览 | 🚧 |
| 领域深潜 | 🌐 CNI 深潜 | 🚧 |
| 面试题库 | 网络面试题集 | 🚧 |
| 面试策略 | 面试策略 | 🚧 |

## 🚀 快速开始（本地开发）

```bash
git clone https://github.com/callmebg/k8s-guide.git
cd k8s-guide
npm install
npm run docs:dev
# 打开 http://localhost:5173
```

## 🤝 参与贡献

欢迎贡献！请阅读 [贡献指南](CONTRIBUTING.md) 了解：

- 如何选择轨道和模板
- 如何编写 Mermaid 图表
- 如何使用千问万相生成插图
- Frontmatter 规范

[提 Bug](https://github.com/callmebg/k8s-guide/issues/new?template=bug-report.md) ·
[建议新内容](https://github.com/callmebg/k8s-guide/issues/new?template=content-request.md) ·
[改进建议](https://github.com/callmebg/k8s-guide/issues/new?template=improvement.md)

## 📄 许可证

[MIT License](LICENSE) © 2026 callmebg
