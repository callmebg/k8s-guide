# 实验：Gateway API

配套文章：[20. Gateway API](/beginner/20-gateway-api)

## 步骤

1. `bash setup.sh` — 创建集群 + 安装 Gateway API CRD + Nginx Gateway Controller + 后端服务
2. `kubectl get gatewayclass` — 查看可用的 GatewayClass
3. `kubectl apply -f manifests/gateway.yaml` — 创建 Gateway 实例
4. `kubectl get gateway` — 确认 Gateway 就绪
5. `kubectl apply -f manifests/httproute.yaml` — 创建 HTTPRoute（等价于 Ingress 路由）
6. `kubectl get httproute` — 查看路由规则
7. `curl localhost` — 验证根路径 → web 服务
8. `curl localhost/api` — 验证 /api → api 服务
9. `kubectl apply -f manifests/canary-route.yaml` — 创建权重分流路由
10. `for i in $(seq 1 10); do curl -s localhost/canary; done` — 观察 80/20 分流
11. `bash teardown.sh` — 清理
