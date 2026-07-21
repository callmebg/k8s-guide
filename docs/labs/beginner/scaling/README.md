# 实验：扩缩容与 HPA

配套文章：[08. 扩缩容与发布](/beginner/08-scaling-rollout)

## 步骤

1. `bash setup.sh` — 安装 Metrics Server + 创建 HPA
2. `kubectl get hpa` — 查看 HPA 状态
3. 模拟压力（另一个终端）：`kubectl run load-gen --image=busybox --rm -it -- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"`
4. 观察自动扩容：`kubectl get hpa -w`
5. 停止压力测试，等待自动缩容
6. `bash teardown.sh` — 清理
