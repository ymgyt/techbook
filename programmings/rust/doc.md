# Document

* `#![warn(rustdoc::broken_intra_doc_links)`

## Link

```rust
struct Foo

/// # Header
/// [`Foo`]
fn foo() { }

/// document comment [hoge][h]
///
/// [h]: Hoge
fn bar() {}

/// implementation of [positional parameters].
///
/// [positional parameters]: std::fmt#formatting-parameters
struct MySpecialFormatter;

```

* scopeにはいっていると[`Foo`]でそのまま参照できる
* `[msg][id]` とlinkの実態を分けて書く方法もある
* `Self`,`self`,`super`,`crate`も使える

## `//!`

* `///`は直下のitemにcommentを付与する
* `//!`はそのcommentを含んでいるitemにcommentを付与する
  * `lib.rs`の先頭に書くとcrateにcommentできる


## Code example


```rust
/// ```no_run
/// use k8s_openapi::api::core::v1::Node;
/// use kube::runtime::{reflector, watcher, WatchStreamExt, watcher::Config};
/// use futures::{StreamExt, future::ready};
/// # use kube::api::Api;
/// # async fn wrapper() -> Result<(), Box<dyn std::error::Error>> {
/// # let client: kube::Client = todo!();
///
/// let nodes: Api<Node> = Api::all(client);
/// let node_filter = Config::default().labels("kubernetes.io/arch=amd64");
/// let (reader, writer) = reflector::store();
///
/// // Create the infinite reflector stream
/// let rf = reflector(writer, watcher(nodes, node_filter));
///
/// // !!! pass reader to your webserver/manager as state !!!
///
/// // Poll the stream (needed to keep the store up-to-date)
/// let infinite_watch = rf.applied_objects().for_each(|o| { ready(()) });
/// infinite_watch.await;
/// # Ok(())
/// # }
/// ```
fn foo() {}
```

* `no_run`: 実行したくない場合に付与する
  * これによってlet `foo: Foo = todo!()`が書ける

* `#`をつけるとdocのcompile上は参照されるが、docには現れなくなる
  * 全体をwrapする関数であったり、冗長なuseであったり、戻り値に付与してsimpleにできる
  
