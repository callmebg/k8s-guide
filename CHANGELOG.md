# Changelog

本项目的所有重要变更均记录在此文件中。

格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added
- OG/Twitter Card 社交分享 meta 标签（og:image、twitter:card 等）
- 面试侧边栏 T 型阅读路径指引
- 文章底部「发现问题？点击反馈」链接
- K8s 版本兼容标注（基于 v1.31.0）

### Fixed
- 修复 08-scaling-rollout.md 中 Metrics Server `--kubelet-insecure-tls` 缺少上下文说明的问题

## [0.3.0] — 2026-07-23

### Added
- 初学者轨道扩展至 30 篇（从 17 篇扩到 30 篇 + 毕业页）
- 侧边栏 3 段式重构（基础入门 / 生产化 / 进阶实战）
- 面试轨道：新增调度概念速览、CNI 深潜、网络面试题库、面试策略

### Changed
- 初学者轨道按学习阶段分组，降低认知负荷

## [0.2.0] — 2026-07-22

### Added
- Vercel 部署配置（vercel.json）
- 双轨站点上线：初学者轨道 + 求职者轨道

### Changed
- Node.js 版本升级至 22
- 从 GitHub Pages 迁移至 Vercel 部署

## [0.1.0] — 2026-07-22

### Added
- MVP 内容：17 篇初学者文章 + 10 个动手实验
- 双轨知识结构设计（初学者 / 求职者）
- VitePress 文档站点 + Mermaid 图表支持
- GitHub Actions CI（lint → build）
- markdownlint 规范
- 文章模板体系（beginner-template + interview-deep-dive-template）
- CONTRIBUTING.md、CODE_OF_CONDUCT.md
- 实验脚本体系（setup.sh / teardown.sh / manifests）

[Unreleased]: https://github.com/callmebg/k8s-guide/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/callmebg/k8s-guide/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/callmebg/k8s-guide/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/callmebg/k8s-guide/releases/tag/v0.1.0
