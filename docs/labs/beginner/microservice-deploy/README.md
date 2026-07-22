# 实验：综合实战 - 微服务部署

配套文章：[30. 综合实战：微服务部署](/beginner/30-microservice-deploy)

## 步骤

1. `bash setup.sh` — 一键部署 30 篇文章学到的全套微服务栈
2. `kubectl get all -n prod` — 查看所有组件
3. `curl -k https://localhost/` — 通过 Ingress 访问前端
4. `curl -k https://localhost/api/health` — 访问后端健康检查
5. `curl -k -X POST https://localhost/api/users ...` — 创建用户
6. `kubectl get hpa -n prod --watch` — 观察 HPA 自动扩缩
7. `kubectl exec -n prod deploy/frontend -- wget -q -O- pg-svc:5432 --timeout=3` — 验证 NetworkPolicy 隔离
8. `bash teardown.sh` — 清理
