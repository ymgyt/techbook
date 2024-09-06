# Helix Configuration

`~/.config/helix/config.toml`

### Key remap

```toml
[keys.normal]
"'" = ":buffer-close" # Close buffer with single quote

# z -> j とおした場合を表現できる
[keys.normal.z]
j = "half_page_down" # Not using scroll down(just one line)
```

### Shell

* `:sh`, `:pipe`等で実行されるshellを指定できる

```toml
# nushellを設定する場合
shell = ["nu", "--stdin", "--commands"]
```
