# Job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
spec:
  # 何回成功すれば良いか
  completions: 1
  # 同時に起動するPod数
  parallelism: 1
  # retry回数
  backoffLimit: 10
  # ttl
  ttlSecondsAfterFinished: 600
  # Podのschema
  template:
    spec:
      containers:
        - name: tinypod
          image: ymgyt/tinypod
      restartPolicy: "OnFailure"
```

* `ttlSecondsAfterFinished`: job完了後に削除されるまでの時間
* `template`はimmutable fieldなので既存のjobがある状態では更新できない
  * 古いjobを消すか、nameをuniqueする


## lifecycle

jobは完了後に自動的に削除されないので、なにもしないとjobとそれから作られたPodは存在し続ける。
