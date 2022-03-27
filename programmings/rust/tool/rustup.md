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

## Usage

```
# toolchaingの確認
rustup show


# nightlyのinstall
rustup install nightly


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
