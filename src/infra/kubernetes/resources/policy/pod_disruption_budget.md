# PodDisruptionBudget

https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/pod-disruption-budget-v1/

* `kubectl drain`でPodをevictする際に維持されなければいけないpod数を指定できる
  * この要求をみたせないと`kubectl drain`がblockする
* `Deployment`のupdate strategyとは別の話で影響しない?

