# Pod disruption budget

* `minAvailable: 10`: 最低でも10台のPodが稼働(disruption中でも)
* `minAvaialble: 50%`: 稼働中のPodの50
  * round up to nerest integerなので、7 Podsの場合は3.5 -> 4になる


## Example

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
