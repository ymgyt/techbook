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
 
 
## Vaultとは

secretの具体例

* AuthN(authentication)
* AuthZ(authorization)
* username
* database credential
* api token
* TLS Certification

Secret sprawlが問題。  
具体的にはplain textにあったり、source codeにあったり, ansibleのようなprovisioning toolに定義してあったりする。  
これらに具体的に誰がアクセスしたかを知らない。  
periodic rotationできていない。 
Vaultはまずこれらsecretをcentralizingする + encryptする
さらにaccess controlを提供する
Audit trailも提供する

つまり最初の提供価値は散逸したcredentialを1箇所にまとめて暗号化した上で、access controlとauditのlayerで保護する点にある


次の課題。
applicationはsecretを保持するのが苦手。loggingしたりexceptionに吐いてしまうかも。
つまりapplicationはtrustedでない。
そこでdynamic secret。
* applicationにはephemeralなcredentialを渡す。
* clientごとにunique。これによってrevokeする際に全systemが一時的にダウンすることを避けられる 

Vaultはplaggableになっている。具体的には
* Auth plugin
* Audit plugin
* Storage abckend
* Secret backend