# 实验：Service

配套文章：[06. Service](/beginner/06-service)

## 步骤

1. `bash setup.sh` — 创建 Deployment + ClusterIP Service
2. `kubectl get services` — 查看 Service
3. 集群内访问测试：`kubectl run curl-test --image=curlimages/curl --rm -it -- curl nginx-svc`
4. 端口转发：`kubectl port-forward service/nginx-svc 8080:80`，浏览器打开 `http://localhost:8080`
5. `bash teardown.sh` — 清理
