# kubeadm

## 概要

### kubeadmがやってくれること

* Generates `/etc/kubernetes` directory
* Generates a self-signed CA to set up identities for each component
* Put generated certificate 
* Generates static Pod manifests into `/etc/kubernetes/manifests`
* Makes all necessary configurations


### kubeadmがやってくれないこと

* kubeletのinstall

## Usage

```shell
kubeadm init \
  --pod-network-cidr=10.244.0.0/16
  
# join tokenを表示する
kubeadm token create --print-join-command

# workerをclusterにjoinさせる
# master nodeのkubeadm token create --print-join-commandを実行する
```

## PKI

* `/etc/kubernetes/pki`
