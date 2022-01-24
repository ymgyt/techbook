# Cargo

## `.cargo/config`

cargoが参照してくれる設定file。

```toml
[build]
target = "thumbv7em-none-eabihf"

[target.thumbv7em-none-eabihf]
runner = 'hf2 elf'
rustflags = [
    "-C", "lin-arg=-Tlink.x",
]
```

こうかくと`cargo build`が`cargo build --target thumbv7em-none-eabihf`となる。  
runnerを指定すると、`cargo run`実行時に、runnerをよびだしてくれる。  
`hf2 elf target/thumbv7em-none-eabihf/debug/app`がよばれる。

## Cargo.toml

### multi binary

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


### features

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
features = ["derive", "parsing", "printing"] optional = true
```

### workspace

```toml
[workspace]

members = [
    "xxx",
    "yyy",
]
```

### Specifying dependencies version

* `xxx = "0.1.2`は`"^0.1.2"`と解釈される
* `^1.2.3`のような指定をcaret requirementsという
  * 一番左の0でない数字をincrementしないかぎりupdateが許可されると解釈する
  * `^1.2.3`の場合は`2.0.0`にならない限りどのversion upもうけいれる

## install

```sh
cargo install --path . --locked
```

* defaultでは`Cargo.lock`が参照されない
  * `--locked`を付与すると`Cargo.lock`が参照されinstallの再現性が向上する
