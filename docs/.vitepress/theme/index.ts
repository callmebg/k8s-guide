import DefaultTheme from 'vitepress/theme'
import { h } from 'vue'
import type { Theme } from 'vitepress'

export default {
  extends: DefaultTheme,
  Layout: () => {
    // @ts-ignore - accessing DefaultTheme.Layout
    return h(DefaultTheme.Layout, null, {
      'doc-footer-before': () => {
        return h('div', { class: 'k8s-version-info' }, [
          h('span', { class: 'k8s-version-badge' }, '基于 Kubernetes v1.31.0 验证'),
        ])
      },
    })
  },
} satisfies Theme
