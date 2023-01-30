# Vault

## Memo

* Cluster
  * nodeはActive or Stanbyに分類される
  * Activeはcluster内で1node
  * Clusterの機能はenterprise,oss両方使える
    * Oss版だとstanbyはactiveにrequestをredirectするのみ
* Path
  * `/sys/health` healthcheck用
    * active nodeは200返して, stanbyは429返す

* Storage backend
  * Integrated storage
    * Vaultがnodeに情報をもつ
    * replicationもできそう?
    * Raft storageとも呼ばれる
    * node間でnetwork接続が必要
      * clusterがdata centerやcloud regionに閉じている必要がある


## 導入における検討事項

* Enterprise or Open-Source
* Will Vault deployed on a public cloud, on-premises, or both?
* Will Vault be provisioned using Terraform, scripts, or manually?
* What storage backend will Vault use to store its data?
* What secrets engines will be initially consumed?
* What performance and operational alerts should be configured?
 
 