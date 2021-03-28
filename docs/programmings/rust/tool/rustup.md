# rustup

## Usage

```
# toolchaingの確認
rustup show


# nightlyのinstall
rustup install nightly


# 最新版にupdate
rustup update

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
