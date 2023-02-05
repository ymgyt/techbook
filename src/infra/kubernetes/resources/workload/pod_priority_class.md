# PodPriorityClass

https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/priority-class-v1/

## Mental model

まず`PrioriClass`を作成する

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000000
globalDefault: false
description: "この優先度クラスはXYZサービスのPodに対してのみ使用すべきです。"
```

次に`Pod`から参照する

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  priorityClassName: high-priority # 👈 PriorityClass.metadata.nameを参照
```
