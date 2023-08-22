# PodPriorityClass

PriorityClassを高く設定しておくことで、priorityの低いpodをnodeから退避させて配置してくる。
https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/priority-class-v1/
* Podがscheduleできない場合、優先度の低いPodを追い出す(preempt)する仕組み
* 初期状態で`system-cluster-critical`と`system-node-critical`が存在しており、system componentのschedulingを保証している
  * これはuserが指定できる値より高い値が設定されているので、誤ってこれらを退避させてしまうことはない

## Mental model

まず`PrioriClass`を作成する

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000000
globalDefault: false
preemptionPolicy: PreemptLowerPriority
description: "この優先度クラスはXYZサービスのPodに対してのみ使用すべきです。"
```

* `preemptionPolicy`: Podがschedulingできない際に他のPodをどうするかについて
  * `PreemptLowerPriority`: default. 自分より低い優先度のPodをpreemptする
  * `Never`: 他のPodをpreemptしないので、自然に空きリソースがあれば使うを実現できる


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


