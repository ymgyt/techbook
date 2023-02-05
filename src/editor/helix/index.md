# helix

## Install

sourceからbuildする
```shell
git clone --recurse-submodules --shallow-submodules -j8 https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term
```

## Config

`~/.config/helix/config.toml`


## Debug

* defaultでは`$HOME/.cache/helix/helix.log`に出力される  
  * 正確には`etcetera`の`base_strategy()`で決まる
* `hx -v` でINFOをloggingできる。`-vv`でWARN
* code上では`log::info!()`を使う

