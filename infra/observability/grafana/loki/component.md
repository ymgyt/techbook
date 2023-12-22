# Component

* Distributor
  * Write path(書き込み処理)の一次受け
  * requestのvalidationの責務をもつ
  * stateless
  * labelをsortしてhashを一意にもする
  * Rate limitをtenantごとに適用する
  * 書き込みrequestはingesterにforwardする
    * ここで複数のingesterにforwardしてdata lossに対処する

* Ingester
  * log dataをstorage backendに書き込む責務をもつ

* Query frontend
  * optionalでread pathの一次受け
  * stateless
  * cache, queryのqueuing, query分割
    * 分割はquerierのoom対策になる

* Querier
  * LogQLでqueryを処理する責務をもつ

* Ruler
  * Querierに定期的にqueryを発行して、AlertMangerにalertを飛ばす

* Compactor
  * 定期的に圧縮してくれる

* Table Manager
  * S3系使う時は不要?

## Architecture

* gateway
  * grafanaがやり取りするrest server?
* read component
  * object storageからreadする
  * gatewayとやり取り
* write component
  * object storageにwriteする
  * gatewayとやり取り

  
