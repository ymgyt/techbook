# sccache - Shared Compilation Cache

## Usage


```shell
export RUSTC_WRAPPER=path/to/sccache
cargo build
```

### Config

* `$HOME/.cargo/config.toml`

```toml
[build]
rustc-wrapper = "/path/to/sccache"
```

## Cache

* defaultでは`~/.cache/sccache`以下にcacheを保持する

## Install

```shell
brew install sccache

cargo install sccache
```

