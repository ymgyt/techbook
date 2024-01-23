# EKS Add on

* 通常はCluster管理者(利用者)がmanifestをapplyするがいくつかのdefaultをEKS APIを通じて提供してくれる機能
  * 用はEKSがapplyしてくれるResource(Service,Deployment,...)
  * 例: CoreDNS等

* Default Addon
  * defaultでinstallされているaddon
  * APIやconsoleで確認できないが、kubectl上ではみれる
  * Amazon VPC CNI Plugin
  * CoreDNS
  * kube-proxy
  


## Addon管理


```sh
# clusterにinstallされているaddonの確認
aws eks describe-addon \
  --cluster-name  my-cluster \
  --addon-name adot \ 
  --profile foo


# adot addonのversionの確認
 aws eks describe-addon-versions \
  --addon-name adot \
  --kubernetes-version 1.28

# addonの更新
aws eks update-addon \
  --cluster-name my-cluster \
  --addon-name adot \
  --addon-version v0.58.0-eksbuild.1 \
  --resolve-conflicts PRESERVE 
```

* `aws eks update-addon`
  * `resolve-conflicts` 設定の衝突の解決方法
    * OVERWRITE: userの設定を上書きする
    * NONE: なにもしない(PRESERVE)となにが違う?
    * PRESERVE: userの設定を保持する
