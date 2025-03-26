 # Capacity

* 専用のQuery実行のための計算リソースを確保(provisioning)する仕組み
  * デフォルトでは全ユーザで共通のリソースを利用しているが、これを専有する仕組み
* 従量課金ではなく、provisioningベースで課金される
* Athena側でqueueにいれられたくないqueryをサポートできる

## Reference

* [公式ブログ Athenaのプロビジョンドキャパシティのご紹介](https://aws.amazon.com/jp/blogs/news/introducing-athena-provisioned-capacity/)
