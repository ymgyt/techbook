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
* `progressDeadlineSecond`: deploymentが失敗と評価されるまでの秒数

https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/


## Rolling update

* Podを一斉に入れ替えるのではなく順番に入れ替える。  
* `spec.strategy.type: RollingUpdate`を指定する
* `spec.strategy.rollingUpdate`
  * `maxSurge` 新規にdeployするPodをいくつ同時にdeployするか
    * `30%`を指定した場合、新旧ReplicaSetのPod数が130%になる
  * `maxUnavailable` deploy時に停止する旧Podの数。`25%`のような指定も可能。
    * 旧ReplicaSetと親ReplicaSetで起動しているPod数の合計がmaxUnavailableを上回らないように調整される
 

