# kube-proxy

* Clusterの各Nodeにはkube-proxyがいる。
* kernel levelのrules(iptables)を変更する

## Serviceの実装

Service resourceを作成するとkube-proxyがServiceのIPとforwarding先のpodのIP群の関係を定義する。
