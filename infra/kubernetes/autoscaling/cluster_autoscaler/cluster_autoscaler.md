# Cluster Autoscaler

* 一定の条件に基づいてClusterのnodeを増減させる仕組み
  * Nodeのresource不足でPodのschedulingが失敗したときにnodeを増やす
  * 他のnodeにpodを集約できるならnodeを減らす

* Nodeで利用されている計算resourceはPodのrequestに基づいて計算する
  * 実際に使っているresourceよりも多くのresourceをrequestしている場合、不要にscaleupが起こる可能性がある

## Podをevictさせない

* 
