# Scheduling

Podをどのnodeにschedulingさせるかについて。


## Affinity

Podをどこに配置するかに関する指定。

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
