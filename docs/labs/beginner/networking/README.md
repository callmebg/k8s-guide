# 实验：网络基础

配套文章：[09. 网络基础](/beginner/09-networking-basics)

## 步骤

1. `bash setup.sh` — 安装 Ingress Controller + 创建两个应用 + Ingress
2. DNS 测试：`kubectl run dns-test --image=busybox --rm -it -- nslookup web`
3. 访问根路径：`curl localhost`（Nginx 欢迎页）
4. 访问 API：`curl localhost/api`（Hello from API）
5. `bash teardown.sh` — 清理
