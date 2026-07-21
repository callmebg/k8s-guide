import { defineConfig } from 'vitepress'
import { withMermaid } from 'vitepress-plugin-mermaid'

export default withMermaid(defineConfig({
  title: 'K8s Guide',
  description: 'Kubernetes 中文学习指南 — 从入门到面试的一站式 K8s 学习指南',
  lang: 'zh-CN',

  sitemap: {
    hostname: 'https://k8s-guide.vercel.app',
  },

  lastUpdated: true,

  head: [
    ['meta', { name: 'theme-color', content: '#3eaf7c' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'K8s Guide - Kubernetes 中文学习指南' }],
    ['meta', { property: 'og:description', content: '从入门到面试的一站式 K8s 学习指南' }],
  ],

  themeConfig: {
    logo: '/logo.svg',
    siteTitle: 'K8s Guide',

    nav: [
      { text: '首页', link: '/' },
      { text: '🌱 初学者', link: '/beginner/01-what-is-k8s' },
      { text: '💼 求职者', link: '/interview/system-overview' },
    ],

    sidebar: {
      '/beginner/': [
        {
          text: '🌱 初学者轨道',
          items: [
            { text: '01. 什么是 Kubernetes', link: '/beginner/01-what-is-k8s' },
            { text: '02. 安装 Kind', link: '/beginner/02-install-kind' },
            { text: '03. 第一个 Pod', link: '/beginner/03-first-pod' },
            { text: '04. Deployment', link: '/beginner/04-deployment' },
            { text: '05. ReplicaSet', link: '/beginner/05-replicaset' },
            { text: '06. Service', link: '/beginner/06-service' },
            { text: '07. ConfigMap 与 Secret', link: '/beginner/07-configmap-secret' },
            { text: '08. 扩缩容与发布', link: '/beginner/08-scaling-rollout' },
            { text: '09. 网络基础', link: '/beginner/09-networking-basics' },
            { text: '10. 存储基础', link: '/beginner/10-storage-basics' },
            { text: '🎓 毕业啦', link: '/beginner/graduation' },
          ],
        },
      ],
      '/interview/': [
        {
          text: '💼 求职者轨道',
          items: [
            { text: '系统全景图', link: '/interview/system-overview' },
          ],
        },
        {
          text: '广度速览',
          items: [
            { text: '网络概念速览', link: '/interview/breadth/networking-review' },
            { text: '调度概念速览', link: '/interview/breadth/scheduling-review' },
          ],
        },
        {
          text: '领域深潜',
          items: [
            { text: '🌐 CNI 深潜', link: '/interview/deep-dive/cni-deep-dive' },
          ],
        },
        {
          text: '面试准备',
          items: [
            { text: '网络面试题', link: '/interview/question-bank/networking' },
            { text: '面试策略', link: '/interview/interview-strategy' },
          ],
        },
      ],
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/callmebg/k8s-guide' },
    ],

    footer: {
      message: 'K8s Guide — Kubernetes 中文学习指南',
      copyright: 'Copyright © 2026 callmebg | MIT License',
    },

    search: {
      provider: 'local',
      options: {
        translations: {
          button: {
            buttonText: '搜索',
            buttonAriaLabel: '搜索',
          },
          modal: {
            noResultsText: '无法找到相关结果',
            resetButtonTitle: '清除查询条件',
            footer: {
              selectText: '选择',
              navigateText: '切换',
              closeText: '关闭',
            },
          },
        },
      },
    },

    outline: {
      label: '本页目录',
    },

    docFooter: {
      prev: '上一篇',
      next: '下一篇',
    },

    lastUpdated: {
      text: '最后更新于',
    },

    returnToTopLabel: '回到顶部',
    sidebarMenuLabel: '菜单',
    darkModeSwitchLabel: '主题',
    lightModeSwitchTitle: '切换到浅色模式',
    darkModeSwitchTitle: '切换到深色模式',
  },

  mermaid: {
    // Mermaid config options
  },
}))
