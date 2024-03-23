# Karpenter


## KarpenterとCluster autoscaler(CAS)の比較

| - | Karpenter | Cluster Autoscaler |
| --- | --- | --- |
| ASG | 利用しない | 利用する |
| Kuberentes version | 特定のversionに依存しない | 特定のversionが必要 |

* CASはNodeGroup(EC2 ASG)の設定にしたがって追加される
  * NGごとに1 instance size
  * instance sizeごとにNGが必要


## Disruption

Nodeの停止方法

* Manual
  * kubectl
* Expiration
  * Nodeが指定した時間起動
* Consolidation
  * Costの観点からPodがいなかったり移動させたりする
    * Node上の全てのPodが他のNodeに移動可能
* Drift
  * NodePoolのManifestのspecと不一致が起きたら
* Interruption
  * Maintenance event等
