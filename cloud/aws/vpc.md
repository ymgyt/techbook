# VPC

Amazon Virtual Private Cloudについて。

## Subnet

* 一つのroute tableを持つ
  * 当該route tableがinternet gatewayへのrouteをもっていればpublic subnet, もっていなければprivate subnet


## NAT

* EC2 instanceにpublic IPを付与せずにinternetとの通信を可能にしたい場合に登場する。
* private subnet内のEC2 instanceにinternetとの通信を可能にするが、外からprivate subnet内に通信を確立することはできない。
* private subnetのroute tableに`0.0.0.0/0`をNAT instanceにroutingさせるrouteをもたせる。
* NAT Instance自体はEIP(orPublic IP)をもち、public subnetに接続されている。
