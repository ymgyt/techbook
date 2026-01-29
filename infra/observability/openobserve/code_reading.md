# Code Reading

## Init

起動時の初期化処理

* `main.rs`
  * `common::infra::cluter::register_and_keep_alive()`
    * `common::infra::cluter::nats::register_and_keep_alive()`
      * `common::infra::cluster::nats::register()`
        * `infra::dist_lock::lock("/nodes/register",...)` lockってなんだ?
    * `common::infra::cluster::check_node_status()` を実行するtaskをspawn
      * ここで何しているか確認する


## 認証

### gRPC

* main.rsで、check_auth interceptorをcomposeしている(component共通)
* 実装は `handler::grpc::auth::check_auth()`

1. `authorization` metadataをチェック
2. internal tokenを取得して判定
  * どこで生成されてる？infra initでやってはいる
3. `organization` metadataをチェック(設定でkey名を変えられはする)
4. `-H autorization: basic base64_std(username:password)`という前提で、decode
5. root userかusername(email address)で判定
  * rootの場合は、`ROOT_USER`から取得
  * normal userの場合はcached userを取得
6. 判定処理(tokenはservice account想定か?)
  * `User.token` == `password` 
  * or `User.password` == `password`
  * or `User.password` == `hash(password, User.salt)`

## Global variables

* `common::infra::config::ROOT_USER` root userの実態を保持

## 読むList

* `common::infra::cluster::nats::register()`

* どこでroot userが作成される？
* grpcはどうやってroutingされている？
