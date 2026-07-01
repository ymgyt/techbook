# Registry

* cargoはcratesを "registry" から fetchする
  * crates.io はdefault registry

* registry は "index" をもつ
  * searchable list of crates

* crate を publishするためのweb api を一般的には備える

* crates.io は他registryに依存している packageをサポートしない


## Alternate Registryの利用方法

`.cargo/config.toml` にregistryの設定を書く
```toml
[registries]
my-registry = { index = "https://my-intranet:8080/git/index" }
```

もしくは、環境変数でも指定できる
`export CARGO_REGISTRIES_MY_REGISTRY_INDEX=https://my-intranet:8080/git/index`

`Cargo.toml`
```toml
[package]
name = "my-project"

[dependencies]
other-crate = { version = "1.0", registry = "my-registry" }
```


## cargoからのpublish

```sh
cargo login --registry=my-registry
cargo publish --registry=my-registry

# or
export CARGO_REGISTRIES_MY_REGISTRY_TOKEN "token"
cargo publish --registry=my-registry

# or
cargo publish --registry=my-registry --token $REGISTRY_TOKEN
```

* `cargo login` は`$HOME/.cargo` 配下の `credentials.toml` に token を保存する

## Registry Protocol

* `git` と `sparse` をサポート

## Registry hosting

* 最低限の機能は、`cargo package` で作成できる `crate` を含む、git repository があればいい
  * [Index format](https://doc.rust-lang.org/cargo/reference/registry-index.html)



## References

* [Running a Registry](https://doc.rust-lang.org/cargo/reference/running-a-registry.html)
* [Registry Authentication](https://doc.rust-lang.org/cargo/reference/registry-authentication.html)
* [Credential Provider Protocol](https://doc.rust-lang.org/cargo/reference/credential-provider-protocol.html)
* [Registry Web API](https://doc.rust-lang.org/cargo/reference/registry-web-api.html)
* [Third party registries](https://github.com/rust-lang/cargo/wiki/Third-party-registries)
