# testcontainers

* rustからdockerを起動してpostgreのようなDBを立ち上げられる
  * docker compose upしてからtestを実行するというようなことを避けられる
  * test caseごとにcontainerを立ち上げられる


* 利用方法
  * container imageの定義
  * instanticate


## Container Imageの定義

* `Image` traitの実装を用意する
  * 自前で定義してもよい
  * `GenericImage` を使うこともできる

* `Image`は`Into<ContainerRequest<Image>>`を実装している
  * Containerの起動ロジックをもつ`AsyncRunner`は`Into<ContainerImage<Image>>`に genericにimplされている


```rust
use testcontainers::{
    ContainerAsync, CopyDataSource, CopyToContainer, Image, core::WaitFor, runners::AsyncRunner,
};

#[derive(Debug, Clone)]
pub struct Postgres {
    env_vars: HashMap<String, String>,
    copy_to_sources: Vec<CopyToContainer>,
}

impl Image for Postgres {
    fn name(&self) -> &str {
        Self::NAME
    }

    fn tag(&self) -> &str {
        Self::TAG
    }

    fn ready_conditions(&self) -> Vec<WaitFor> {
        vec![
            WaitFor::message_on_stderr("database system is ready to accept connections"),
            WaitFor::message_on_stdout("database system is ready to accept connections"),
        ]
    }

    fn env_vars(
        &self,
    ) -> impl IntoIterator<Item = (impl Into<Cow<'_, str>>, impl Into<Cow<'_, str>>)> {
        &self.env_vars
    }

    fn copy_to_sources(&self) -> impl IntoIterator<Item = &CopyToContainer> {
        &self.copy_to_sources
    }
}
```

## Containerの起動

```rust
let pg = Postgres::default().start().await?;

let host = pg.get_host().await?;
// containerの5432に対応するpublishされているportの取得
let port = pg.get_host_port_ipv4(5432).await?;
```

* `AsyncRunner::start`を呼ぶ
* 起動すると、hostとportを取得できるので、接続ロジックにつなげる
