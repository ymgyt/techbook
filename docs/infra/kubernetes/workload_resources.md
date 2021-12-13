# Workload Resources

## Job

Podを作成してコマンドを実行するリソース。

### Example

```yaml
---
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
  namespace: ymgyt
spec:
  template: # Pod schema
    metadata:
      annotations:
        ymgyt.io/key: "value"
      labels:
        # EKSはここで実行環境を制御できるらしい
        worker: fargate
    spec:
      containers:
        # ...
```

## Cron Job

### Example

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: knight-export-tjhis-job
spec:
  # jobの同時実行に関する設定。前のjobが実行中の場合に次のjobがどうなるか。
  # * Allow: 次のjobは前のjobが実行中でも走る。
  # * Forbid: 前のjobが実行中の場合、次のjobはskipされる。
  # * Replace: 前のjobをcancelして新しいjobを実行する   
  concurrencyPolicy: Forbid
  
  # 失敗したjobの保持数。
  failedJobHistoryLimit: 5
  
  # 成功したjobの保持数。
  successfulJobsHistoryLimit: 5
  
  # 次の実行を中止するか。enable/disable的なflagと理解。 
  suspend: false
  
  jobTemplate:
    spec:
      # jobが完了するまでの制限時間。
      # retry(backoff)をまたいでも継続するので、backoff limitに達していなくても
      # この制限時間を超えるとjobは失敗する。
      activeDeadlineSeconds: 3600

      # jobのretry数。jobが失敗とみなされるまでに何回retryするか。
      # 1とした場合、都合2回実行される?
      backoffLimit: 3

      # 都合何個のJob(Pod)が成功を記録すべきか。
      # Queueからtaskをとってくるタイプのjobで指定したりするらしい。
      # 典型的な1jobでは1
      completions: 1
      
      # 同時実行する数。
      # jobの実行パターンに応じて複数にするらしい。
      # 典型的な1jobでは1
      parallelism: 1

      # jobが終了したあと残しておく時間。
      # この時間が経過したときに誰かが勝手に消してくれるのかわかっていない。
      ttlSecondsAfterFinished: 0
        template:
          metadata:
            # metadata...
          spec:
            restartPolicy: Never
            containers:
              - # container definition ...
```
