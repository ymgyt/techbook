# Karpenter


## KarpenterとCluster autoscalerの比較

| - | Karpenter | Cluster Autoscaler |
| --- | --- | --- |
| ASG | 利用しない | 利用する |
| Kuberentes version | 特定のversionに依存しない | 特定のversionが必要 |


## Scheduling

### Topology Spread

The three supported topologyKey values that Karpenter supports are:

* `topology.kubernetes.io/zone`
* `kubernetes.io/hostname`
* `karpenter.sh/capacity-type`



## Disruption

Nodeの停止方法

* Manual
  * kubectl
* Expiration
  * Nodeが指定した時間起動
* Consolidation
  * Costの観点からPodがいなかったり移動させたりする
* Drift
  * Manifestのspecと不一致が起きたら
* Interruption
  * Maintenance event等
