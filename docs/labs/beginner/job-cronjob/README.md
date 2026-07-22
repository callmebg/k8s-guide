# 实验：Job 与 CronJob

配套文章：[16. Job 与 CronJob](/beginner/16-job-cronjob)

## 步骤

1. `bash setup.sh` — 创建成功 Job + 失败 Job + CronJob
2. `kubectl get jobs` — 查看 Job 状态（pi-calc 应该 Complete，fail-job 重试中）
3. `kubectl logs -l job-name=pi-calc` — 查看成功 Job 的输出（圆周率 2000 位）
4. `kubectl get pods -l job-name=fail-job` — 观察失败 Job 的重试（backoffLimit: 2 = 3 个 Pod）
5. 等 1-2 分钟后 `kubectl get jobs` — 观察 CronJob 每分钟触发新 Job
6. `kubectl get cronjob heartbeat` — 查看 CronJob 的 LAST SCHEDULE 时间
7. `bash teardown.sh` — 清理
