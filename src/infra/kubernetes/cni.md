# Container Network Interface


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
