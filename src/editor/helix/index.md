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

## Commands

whitespaceをrenderingする. `:set whistespace.render (all | none)`


## Lang server

### 設定の渡し方

lang serverへの設定の渡し方

1. `.helix` dirをproject rootに作成
1. `.helix/languages.toml`を作成
1. 以下の設定を追加

```toml
[[language]]
name = "rust"
config = { cargo = { features = ["some_features"] } }
```

別の書き方として

```toml
[[language]]
name = "rust"

[languae.config]
cargo.features = ["xxx"]
```

tomlの設定はいい感じにmergeされるので、name = "rust"だけ書いておけばよさそう

### html,css

`npm i -g vscode-langservers-extracted`  

https://www.npmjs.com/package/vscode-langservers-extracted
