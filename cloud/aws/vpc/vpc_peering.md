# VPC Peering

* 二つのVPCを接続し、private IP でroutingできる状態にする
  * VPC間のCIDR は重複できない
* Requester VPC がリクエストし、Accepter VPCが承認して、peeringを作成する
* 各VPCで、他のVPCにroutingするためのrouteをroute tableに追加する
  * VPC-Aのroute table に VPC-BのCIDRからPeeringをtargetとするrouteがある
