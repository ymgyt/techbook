# Language Configuration

各言語ごとの設定

* `languages.toml`に定義する
* 3箇所にある
  1. helixのsource code
    * これがdefaultの設定となる
  2. config directory(`~/.config/helix/languages.toml`)
  3. CWDの`.helix/languages.toml`


## Rust

`[language-server.rust-analyzer.config]`以下がrust-analyzer側の`rust-analyzer.`に渡される

```toml
# 有効にするfeature
[language-server.rust-analyzer.config.cargo]
# rust-analyzer.cargo.features = ["foo"]
features = ["foo"]

# dotでnestもOK
imports.group.enable = true
```

## Nix

```toml
[[language]]
name = "nix"
# save時のformatを有効にする
auto-format = true
# formatterを指定
# hx --health nixで設定を確認できる
formatter = { command = "nixfmt"}
```

