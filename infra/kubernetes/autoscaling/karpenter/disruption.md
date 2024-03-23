# Disruption

Nodeを停止させる全般の機能の抽象化?

`spec.disruption.budgets`


## Disruptionさせない

`karpenter.sh/do-not-disrupt:true`のannotationがあるとdisruptしないようにできる

```yaml
# Workload Level
apiVersion: apps/v1
kind: Deployment
spec:
  template:
    metadata:
      annotations:
        karpenter.sh/do-not-disrupt: "true"

---
# Node Level
apiVersion: v1
kind: Node
metadata:
  annotations:
    karpenter.sh/do-not-disrupt: "true"
```
