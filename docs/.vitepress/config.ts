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
    ['meta', { property: 'og:image', content: 'https://k8s-guide.vercel.app/og-image.png' }],
    ['meta', { property: 'og:url', content: 'https://k8s-guide.vercel.app' }],
    ['meta', { name: 'twitter:card', content: 'summary_large_image' }],
    ['meta', { name: 'twitter:title', content: 'K8s Guide - Kubernetes 中文学习指南' }],
    ['meta', { name: 'twitter:description', content: '从入门到面试的一站式 K8s 学习指南' }],
    ['meta', { name: 'twitter:image', content: 'https://k8s-guide.vercel.app/og-image.png' }],
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
        },
        {
          text: '📦 基础入门 — 把应用跑起来',
          collapsed: false,
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
          ],
        },
        {
          text: '🔧 生产化 — 把应用跑稳',
          collapsed: true,
          items: [
            { text: '11. Namespace 与资源配额', link: '/beginner/11-namespace' },
            { text: '12. 探针与健康检查', link: '/beginner/12-probes' },
            { text: '13. 资源请求与限制', link: '/beginner/13-resource-limits' },
            { text: '14. RBAC 权限管理', link: '/beginner/14-rbac' },
            { text: '15. DaemonSet 与 StatefulSet', link: '/beginner/15-daemonset-statefulset' },
            { text: '16. Job 与 CronJob', link: '/beginner/16-job-cronjob' },
            { text: '17. Helm 包管理', link: '/beginner/17-helm' },
            { text: '18. 日志与监控', link: '/beginner/18-logging-monitoring' },
            { text: '19. 排障方法论', link: '/beginner/19-troubleshooting' },
            { text: '20. Gateway API', link: '/beginner/20-gateway-api' },
          ],
        },
        {
          text: '🚀 进阶实战 — 应对复杂场景',
          collapsed: true,
          items: [
            { text: '21. Init Container 与 Sidecar', link: '/beginner/21-init-container-sidecar' },
            { text: '22. NetworkPolicy 实战', link: '/beginner/22-networkpolicy' },
            { text: '23. Ingress 生产实战', link: '/beginner/23-ingress-production' },
            { text: '24. Pod 安全上下文', link: '/beginner/24-pod-security' },
            { text: '25. Pod Disruption Budget', link: '/beginner/25-pdb' },
            { text: '26. Pod 身份与认证机制', link: '/beginner/26-pod-identity' },
            { text: '27. Custom Resource 入门', link: '/beginner/27-custom-resource' },
            { text: '28. Kustomize 配置管理', link: '/beginner/28-kustomize' },
            { text: '29. 集群升级与维护', link: '/beginner/29-cluster-upgrade' },
            { text: '30. 综合实战：微服务部署', link: '/beginner/30-microservice-deploy' },
          ],
        },
        {
          items: [
            { text: '🎓 毕业啦', link: '/beginner/graduation' },
          ],
        },
      ],
      '/interview/': [
        { text: '💡 建议阅读顺序：全景图 → 广度速览 → 领域深潜 → 题库 → 策略' },
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
            { text: '⏰ 调度深潜', link: '/interview/deep-dive/scheduling-deep-dive' },
            { text: '💾 存储深潜', link: '/interview/deep-dive/storage-deep-dive' },
            { text: '🔒 安全深潜', link: '/interview/deep-dive/security-deep-dive' },
          ],
        },
        {
          text: '面试准备',
          items: [
            { text: '网络面试题', link: '/interview/question-bank/networking' },
            { text: '调度面试题', link: '/interview/question-bank/scheduling' },
            { text: '存储面试题', link: '/interview/question-bank/storage' },
            { text: '安全面试题', link: '/interview/question-bank/security' },
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

    editLink: {
      pattern: 'https://github.com/callmebg/k8s-guide/issues/new?template=bug-report.md&title=[反馈]%20:path',
      text: '发现问题？点击反馈',
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
