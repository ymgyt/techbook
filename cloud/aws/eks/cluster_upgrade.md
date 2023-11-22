# EKS Cluster Upgrade

## TOOD

* https://kubernetes.io/releases/version-skew-policy/#kube-apiserver


## Version Support

EKSがsupportするversionにはsupport期間という概念がある  
versionは上げたら戻せない

* standard support
  * EKSとしてreleaseされてから12ヶ月継続

* extended support
  * standard supportが終了してから14ヶ月継続
  * 追加料金がかかる
    * ただし、developer preview期間中はかからない
    * 1.23から適用
  * 期限がきれると自動でversionがあがる
    * support中のもっとも古いversion

## Componentごとの対応

* Control planeのversionを上げても、managed node groupのversionは変わらないので別途変更が必要
  * Self managedも同様

* Fargate podはupdateされたkubeletの元で再度deployする必要がある

## Memo

1. `kubectl version`でcontrol planeのversionを確認する
1. `kubectl get nodes`でnodeのversionを確認する
  * managed nodes, fargate nodesのversionがcontrol planeのversionと一致しているか確認する
    * control planeが1.27で、nodeが1.26だった場合、まずnodeを1.27にあげる
    * https://docs.aws.amazon.com/eks/latest/userguide/update-managed-node-group.html