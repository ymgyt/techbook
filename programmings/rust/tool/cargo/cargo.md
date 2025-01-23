# Cargo

## install

```sh
cargo install --path . --locked
```

* defaultでは`Cargo.lock`が参照されない
  * `--locked`を付与すると`Cargo.lock`が参照されinstallの再現性が向上する
  * `--locked`を付与しないと`Cargo.toml`で許される限りsemverの最新を利用しようとする

## update

* dependencyのversionをあげる

```shell
# xxxのversionをあげる
cargo update --package xxx

# packageのversionを指定する(downgradeもできる) 
cargo update --precise 1.0.1 -p anyhow
```

## Use specific version

* `cargo +1.59.0 run`

```console
# if not installed
rustup install 1.41.0

cargo +1.41.0 run
```

## Cross compile

* https://github.com/messense/homebrew-macos-cross-toolchains

```shell
brew install x86_64-unknown-linux-musl

export CC_x86_64_unknown_linux_musl=x86_64-unknown-linux-musl-gcc
export CXX_x86_64_unknown_linux_musl=x86_64-unknown-linux-musl-g++
export AR_x86_64_unknown_linux_musl=x86_64-unknown-linux-musl-ar
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=x86_64-unknown-linux-musl-gcc

rustup target add x86_64-unknown-linux-musl

cargo build --target x86_64-unknown-linux-musl

file ./target/x86_64-unknown-linux-musl/debug/binname
```

## Profile

* compiler settingsを変更する方法。  
  * https://doc.rust-lang.org/cargo/reference/profiles.html
* defaultでは`dev`,`release`,`test`,`bench`がある。
* `Cargo.toml`で指定できる

```toml
[profile.dev]
opt-level = 1
overflow-checks = false
```

## Publish

* crates.ioへのpackageの公開

```shell
# login
cargo login ${CRATES_IO_TOKEN}

# check
cargo publish --dry-run

# publish
cargo publish

# workspaceの場合はpackageを指定できる
cargo publish --package member
```

* workspaceでmember間を`mycrate-lib = { path = "../mycrate-lib", version = 0.1.1 }`に指定すると
  * localではpathが利用される
  * cargo publish時にはversionが利用される
  * 従って、依存先が先にcrates.ioにpublishされていなければならない

## Environment variables

cargoが用意してくれる環境変数

* `OUT_DIR` cargo build時の出力先
  * tonic等のprotobuf -> rust code生成で参照されていたりする


## build

* `cargo build --timings`
  * compileに関する情報をhtml等で出力してくれる

## Troubleshoot

### is not applicable to

```sh
cargo -V
error: the 'cargo' binary, normally provided by the 'cargo' component, is not applicable to the '1.76.0-aarch64-apple-darwin' toolchain
```

一度削除する

```sh
rustup component remove cargo
info: removing component 'cargo'
warning: during uninstall component cargo was not found

rustup component add cargo
info: downloading component 'cargo'
info: installing component 'cargo'
```


### can't find crate for `std` 

```sh
error[E0463]: can't find crate for `std`
```

```
rustup component add rust-std 
```
