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
