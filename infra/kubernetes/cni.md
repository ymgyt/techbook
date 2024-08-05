# Container Network Interface

* Networkは複雑で複数の実装方法があるので、kubernetesの機構からnetworkを抽象化したいという課題意識がある
* PodのIP addressがcluster外部からアクセスできるかどうかはCNIの実装次第
  * AWSではVPCのIPのCIDR範囲ならPodのIPを取得する
* kubeletからCNIの実装のpluging(executable)が呼ばれる

## K8s requirements for CNI Plugins

KubernetesはPod間通信の実装をもっておらず、CNIという形で実装されていることを期待している。  
具体的に期待していることは以下。

1. Every Pod gets its own unique IP address.
2. Pods on same node can communicate with that IP address.
3. Pods on different node can communicate with that IP address without NAT


## Impl CNI

NodeのIP rangeとPodのIP rangeはoverlapしてはいけない。  
例えばNode-Aが172.31.1.10, Node-Bが172.31.1.11のとき
Node-AのPodは10.32.1.0/24, Node-BのPodは10.32.2.0/24のような値になる

## Component

* container runtimeとnetwork solutionをつなぐための仕様
* code library
* command line tool for executing CNI plugin

## 参考

* [CNI Essentials](https://tetrate.io/blog/kubernetes-networking/)
