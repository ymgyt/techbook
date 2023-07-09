# Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tinypod
  namespace: tinypod
spec:
  replicas: 2
  selector:
    matchExpressions:
    - key: app
      operator: In
      values: [xxx]
  minReadySeconds: 0
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0%
  revisionHistoryLimit: 10
  progressDeadlineSeconds: 600
  template:
    metadata:
      labels:
        app: tinypod
    spec:
      containers:
      - name: tinypod
        image: ymgyt/tinypod:0.1.0
        ports:
        - name: http
          containerPort: 8001
```

* `selector.matchLabels`は`selector.matchExpressions`のoperatorが`In`の場合と同じ
  * valid operatorは`In`, `NotIn`, `Exists`, `DoesNotExist`
* containerの`ports[].name`を設定しておくとServiceのcontainerPortの指定に利用でき、Service側がcontainerのportを意識しなくてよいので好き
* `minReadySeconds`はreadyとみなされるまでの秒数。0だと起動後に直ぐにreadyと見なされる
* `strategy`
  * `type`は`RollingUpdate`がdefaultで、`Recreate`もある
* `template`は`PodTemplateSpec`なのでpod参照

https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/