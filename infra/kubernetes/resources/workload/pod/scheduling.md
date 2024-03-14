# Scheduling

Podをどのnodeにschedulingさせるかについて。


## Affinity

Podをどこに配置するかに関する指定。  
Affinityは親和性という意味。

### Node affinity

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - antarctica-east1
            - antarctica-west1
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
  containers:
  - name: with-node-affinity
    image: registry.k8s.io/pause:2.0
```

* `IgnoredDuringExecution`はpodをscheduleしたあとにlabelが変更されても気にしないという意味
* `requiredDuringSchedulingIgnoredDuringExecution`
  * 条件が満たされないとpodはscheduleされない
  * `nodeSelectorTerms`は配下の`matchExpressions`をORで評価する
    * `matchExressions`は配下の`key`をANDで評価する
* `preferredDuringSchedulingIgnoredDuringExecution`
  * 考慮するが、条件が満たされなくてもscheduleされる
  * requiredは満たすか満たさないかだが、preferredの方はweightを指定できる
* `matchExpressions.key`
  * `operator`に使えるのは`In`, `NotIn`, `Exists`, `DoesNotExist`, `Gt` and `Lt`

## nodeSelector

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: foo
  nodeSelector:
    disktype: ssd
```

* Nodeを指定するシンプルな方式
* nodeに付与されたlabelを指定する
  * `disktype=ssd`のnodeにのみschedulingされる

## TopologySpreadConstraint

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

### 参考

* [KubbernetesのTopologyとは?](https://zenn.dev/nekoshita/articles/599080c3d0f13e)

### 参考

* [KubernetesのTainsとTolerationsについて](https://qiita.com/sheepland/items/8fedae15e157c102757f)
