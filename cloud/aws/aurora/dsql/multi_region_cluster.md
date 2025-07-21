# Multi Region Cluster

* remote region(pear region)
  * initial clusterへの書き込みがreplicationされる
  * remote, initialどちらにも書ける

* Witness region
  * multi regionに書き込まれたデータを受け取る
  * userにはendpointを提供せず、障害復旧用

* 大陸をまたいだmulti regionはできない
