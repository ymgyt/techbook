# PodDisruptionBudget

https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/pod-disruption-budget-v1/

* `kubectl drain`でPodをevictする際に維持されなければいけないpod数を指定できる
  * この要求をみたせないと`kubectl drain`がblockする
* voluntary disruptionsにおいて考慮される
* `Deployment`のupdate strategyとは別の話で影響しない?


```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: zk-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: zookeeper
```

* `spec.selector`: budgetが適用されるpodをselectする
  * 空の場合はすべてのPodにmatchする(v1)
* `spec.minAvailable`: eviction中であっても維持されなければならないPodの数の指定
  * 直接数を指定できる
  * `50%`のようにpercentの指定も可能
    * 現在の数に対して適用される。切り上げされる。
* `spec.maxUnavailable`: eviction中に落としてよいPodの数の指定


## 参考

* [Specifing a Disruption Budget for your Application](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)
