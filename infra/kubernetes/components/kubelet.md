# kubelet

* Podの`/etc/resolve.conf`を生成して、DNSのIPを記載してくれる

## Config

`/var/lib/kubelet/config.yaml`

## Static Pod

* kubeletが管理するPod 
  * `/etc/kubernetes/manifests`でmanifestを管理
* kube-apiserverが管理しない
  * etcdにも永続化されないので、kubectl等からみえない
