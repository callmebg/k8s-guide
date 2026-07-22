# 实验：Ingress 生产实战

配套文章：[23. Ingress 生产实战](/beginner/23-ingress-production)

## 步骤

1. `bash setup.sh` — 创建集群 + 安装 Ingress Controller + 部署 v1/v2 后端 + Ingress 规则
2. `kubectl describe ingress app-tls` — 查看 TLS 配置
3. `curl -k https://localhost/` — 验证 TLS 终止
4. `curl http://localhost/app/api/hello` — 验证 rewrite
5. `curl http://localhost/` — 验证默认走 v1
6. `curl -H "x-version: v2" http://localhost/` — 验证金丝雀 header 路由到 v2
7. 快速发送 20 个请求验证限流（`for i in $(seq 1 20); do curl -s -o /dev/null -w "%{http_code}\n" http://localhost/; done`）
8. `bash teardown.sh` — 清理
