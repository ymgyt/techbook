# TopologySpreadConstraint

* Podを論理的なgroup(region,ラック,...)に分散させたい課題に対処する
* 前提として、nodeはlabelによってgroupingされている
  * 各nodeにregion=A等がふってある

```yaml
spec:
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app: foo
```

* `maxSkew` `whenUnsatisfiable`の値によって解釈がかわる
  * `whenUnsatisfiable=DoNotSchedule`
    * domainに配置されているPodの最小値との差分がmaxSkewをこえないようになる(結果的にいい感じに分散される)
  * `whenUnsatisfiable=ScheduleAnyway`
    * 参考値になる

* `topologyKey` nodeのlabelのkey
  * このlabelの値が同じnodeは同じgroupと考えられる

* `whenUnsatisfiable` spread constraintをみたせない場合のpolicy
  * `DoNotSchedule` scheduleしない
  * `ScheduleAnyway` topologyを考慮するけど、scheduleしちゃう 

* `labelSelector` constraintの対象になるpodを指定するlabel

* `minDomains` domainの最小数。
  * 意図的にscheduleさせずに、cluster autoscalerを起動させるために使え
  * `whenUnsatisfiable=DoNotSchedule`が前提

## 複数制約

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: mypod
  labels:
    foo: bar
spec:
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        foo: bar
  - maxSkew: 1
    topologyKey: node
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        foo: bar
  containers:
  - name: pause
    image: registry.k8s.io/pause:3.1
```

* `topologySpreadConstraints`が複数ある場合はそれぞれの制約を満たす必要がある(できないとPending)
  * 上記の例では、zone-aにnode 2台、zone-bにnode 1台だと、zoneの制約を満たすために、zone-bに配置したいがそうすると、nodeの制約を満たせなくなる場合がある


## nodeAffinity, nodeSelectorとの関係

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: mypod
  labels:
    foo: bar
spec:
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        foo: bar
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: zone
            operator: NotIn
            values:
            - zoneC
  containers:
  - name: pause
    image: registry.k8s.io/pause:3.1
```

* `nodeAffinity`がある場合はそれにマッチするnodeの中で、tscが考慮される
