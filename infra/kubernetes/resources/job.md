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
  # Podのschema
  template:
    spec:
      containers:
        - name: tinypod
          image: ymgyt/tinypod
      restartPolicy: "OnFailure"
```
