# 实验：Custom Resource 入门

配套文章：[27. Custom Resource 入门](/beginner/27-custom-resource)

## 步骤

1. `bash setup.sh` — 创建集群
2. `kubectl apply -f manifests/websiteinfo-crd.yaml` — 创建 CRD
3. `kubectl get crd | grep example` — 查看 CRD 已注册
4. `kubectl api-resources | grep example` — 查看 API 资源列表
5. `kubectl apply -f manifests/my-website.yaml` — 创建 CR 实例
6. `kubectl get websiteinfos` / `kubectl get wi` — 查看 CR 实例
7. `kubectl apply -f manifests/invalid-website.yaml` — 尝试创建无效 CR（验证 CRD 校验）
8. `kubectl describe wi my-blog` — 查看详情
9. `bash teardown.sh` — 清理
