# EKS Cluster Upgrade

* 上げたら戻せない
* minor version(1.28等)は14 monthサポートされる(standard support)
  * standard support期間を過ぎると12 monthのextended support期間に入る
    * 追加料金がかかる(extended supportがpreview期間中は無料)
  * extended support期間が終わると、自動でsupportされている古いversionにupgradeされる

* Control planeのversionを上げても、managed node groupのversionは変わらないので別途変更が必要
  * Self managedも同様

* Fargate podはupdateされたkubeletの元で再度deployする必要がある