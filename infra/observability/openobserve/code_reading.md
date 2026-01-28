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


## 読むList

* `common::infra::cluster::nats::register()` 
