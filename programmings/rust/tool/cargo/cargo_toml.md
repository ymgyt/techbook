# `Cargo.toml`

## multi binary

crateに複数のbinaryを用意したい場合

```yaml
[package]
# ...
# cargo実行時に指定がなくても動くようにする 
default-run = "ops"

[[bin]]
name = "xxx"
path = "src/main.rs"

[[bin]]
name = "yyy"
path = "src/yyy/bin/yyy.rs"
```

`cargo run --bin yyy`のように実行時に指定する必要がある。ない場合はdefaultが利用される。


## features

```yaml
[package]
name = "foo"
...
[features] 
derive = ["syn"]
default = ["derive"]

[dependencies.syn]
version = "1"
default-features = false
features = ["derive", "parsing", "printing"]
optional = true
```

* `[features]`で定義してそれぞれの依存先を指定する
* `optional = true`を指定したdependencyはdefaultでfeatureとして扱われる

### optional dependencyをfeatureとして扱われることを避ける

```toml
[dependencies]
ravif = { version = "0.6.3", optional = true }
rgb = { version = "0.8.25", optional = true }

[features]
avif = ["dep:ravif", "dep:rgb"]
```

* `dep:xxx`のようにprefix`dep`をつけると暗黙的にfeatureにならなくなる
  * この場合、`ravif`と`rgb`はfeatureにならない

### featureに応じてdependencyのfeatureを有効にする

```toml
[features]
serde = ["libx/serde"]
```

* `crate/feature`のように書くとdependencyのfeatureを有効にできる


## workspace

```toml
[workspace]

members = [
    "xxx",
    "yyy",
]

[workspace.dependencies]
tracing = "1.0"
```

```toml
# member/xxx/Cargo.toml
[dependencies]
tracing = { workspace = true, features = ["hoge"] }

[build-dependencies]
baz.workspace = true
```

* `[workspace.dependencies]`にworkspace共通の依存を宣言できる
  * member側は`workspace = true`を指定する

## Specifying dependencies version

* `xxx = "0.1.2`は`"^0.1.2"`と解釈される
* `^1.2.3`のような指定をcaret requirementsという
    * 一番左の0でない数字をincrementしないかぎりupdateが許可されると解釈する
    * `^1.2.3`の場合は`2.0.0`にならない限りどのversion upもうけいれる


## Package section

```toml
[package]
name = "clc"
version = "0.1.1"
edition = "2021"
license = "MIT OR Apache-2.0"
description = "Calculator command line interface app"
repository = "https://github.com/ymgyt/calculator"
readme = "README.md"
keywords = ["calculator"]
categories = ["command-line-utilities"]
# cargo publish時の制御
exclude = ["/.project", "!/.project/scripts/version.rs"]
default-run = "ops"
```

* categoriesはある程度決まったものがあるのでハマるならそれを利用する
  * https://crates.io/category_slugs

* `exclude`でcargo publishされる際に除外するファイルを指定する
  * gitignore styleらしい

## Dependencies

### crateのrename

```toml
alias = { version = "0.1", registry = "custom", package = "org" }
```

```rust
use alias::module::X; // => resolved to org::module::X
```

* `org` crateをソースコード中では`alias`として利用できる。

## Patch

依存crateを一時的にlocalに向けたい時

### crates

```toml
[dependencies]
uuid = "1.0"

[patch.crates-io]
uuid = { path = "../path/to/uuid" }
```

### git依存のpatch

依存先をgitで指定している場合のpatch。

`Cargo.toml`
```toml
[dependencies]
xxx = { tag = "0.0.64", git = "https://github.com/org/xxx.git" }

[patch."https://github.com/org/xxx"]
raiden = { path = "/Users/ymgyt/rs/xxx" }
```

これでlocalが実際に利用される。