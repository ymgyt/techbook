# workspace

* `Cargo.lock`がshareされる
* `target`がshareされる

```toml
[workspace]
resolver = "2"

members = [
    "xxx",
    "yyy",
]

# packages to exclude from workspace
exclude = []

# 特定のpackageが指定されなかった場合にoperateされる
default-members = []

# packageを指定するとroot packageとなりvirtualと区別される
# [package]
# name = "foo"

# memberに渡せる
[workspace.package]
authors = ["ymgyt"]
edition = "2021"
keywords = []
license-file = ""
readme = "README.md"

[workspace.dependencies]
tracing = "1.0"
```

```toml
# member/xxx/Cargo.toml
[package]
name = "member-1"
authors.workspace = true
edition.workspace = true

[dependencies]
tracing = { workspace = true, features = ["hoge"] }

[build-dependencies]
baz.workspace = true
```

* toplevelの`Cargo.toml`に`[package]`がないとvirtual workspaceとなる
  * `-p|--package`が指定されない場合`--workspace`がつけられたとみなし`cargo check`等を実行する
  * `default-members`が指定されるとそれが対象になる

* `[workspace.dependencies]`にworkspace共通の依存を宣言できる
  * member側は`workspace = true`を指定する

## Specifying dependencies version

* `xxx = "0.1.2`は`"^0.1.2"`と解釈される
* `^1.2.3`のような指定をcaret requirementsという
    * 一番左の0でない数字をincrementしないかぎりupdateが許可されると解釈する
    * `^1.2.3`の場合は`2.0.0`にならない限りどのversion upもうけいれる


