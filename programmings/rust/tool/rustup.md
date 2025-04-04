# rustup

## Concepts

* stableやnightlyといったchannelからreleaseされる単位が`toolchain`
* `toolchain`は`component`の集合
  * `component`は`rustc`,`clippy`とか
  * `toolchain`に含まれている`component`はchannelにより変わる
* `profile`は`component`の集合
  * `minimal`
  * `default`
  * `complete` がある

### Components

* rustc
* cargo
* rustfmt
* rust-std
* rust-docs
* rust-analyzer
* clippy
* miri
* rust-src
* rust-mingw
* llvm-tools
* rustc-dev

### Profile

componentsのgorupのこと
* minimal
  * rustc,rust-std,cargo
* default
  * minimal + rust-docs,rustfmt,clippy
* complete
  * 全部入り。基本つかわない

## Usage

```sh
# toolchaingの確認
rustup show


# nightlyのinstall
rustup install nightly
rustup toolchain install nightly


# 最新版にupdate
rustup update [stable]

# nightly版を実行
rustup run nightly rustc -V

# 短くもかける
rustc +nightly -V
cargo +nightly -V

# doc
rustup doc --std

# 特定のversionを利用する
rustup install 1.15.1
rustup override set 1.15.1

# target tripleを確認する
rustup show

# toolchainの削除
rustup toolchain remove 1.70.0-<target>
```

## toolchainの指定

```
cd <project_root>
echo nightly > rust-toolchain
```

## nightlyの実行

```
rustup run nightly rustc -V
```

## cross compile

```
rustup target add 
```

## Install

* `RUSTUP_HOME` で rustup が利用するdirを指定できる
  * defaultでは `~/.rustup`
* `CARGO_HOME` で cargo等のツールのインストール先を指定できる
  * defaultでは `~/.cargo`

1. `https://sh.rustup.rs | sh` を実行すると、rustup-init.sh が実行される
2. rustup-init.sh の中で、rustup binaryを取得して、`rustup-init` として実行する
3. `rustup-init` として実行されたrustup は toolchainを `~/.cargo/bin`に配置する

### Fedora

```sh
# install rustup-init
sudo dnf install rustup

rustup

rustup toolchain link system /usr
```

* [Fedora rust](https://developer.fedoraproject.org/tech/languages/rust/further-reading.html)


## rustup自身の更新

```sh
rustup self update
```

* `https://static.rust-lang.org/rustup/release-stable.toml` に最新のversionが記載されているのでそれを確認している

```sh
curl https://static.rust-lang.org/rustup/release-stable.toml
schema-version = '1'
version = '1.28.1'
```
