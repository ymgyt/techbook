# Install

## Memo

### Master/Worker共通で必要

* Container Runtime
* Kubelet
  * static podを起動させる
* Kube Proxy

### Master

* Pod
  * api server
  * scheduler
  * controller manager
  * etcd


## Server Provision

* swapを無効にする
 
```text
# swapを無効にする
sudo swapoff -a
```

* portを設定する
  * https://kubernetes.io/docs/reference/ports-and-protocols/
  * Control Plane, Worker nodeごとにportの許可を制限する。(SecurityGroup等)
