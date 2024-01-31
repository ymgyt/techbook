# taplo

## Format toml

```sh
taplo fmt foo.toml
taplo fmt foo.toml --check
```

## Config

* `taplo.toml`に書く


```toml
include = ["Cargo.toml", "crates/**/Cargo.toml"]
exclude = []

[formatting]
align_entries = true
column_width  = 120
reorder_keys  = true
```

* align_entriesを有効にするときれい感がますので良い
* reorder_keysも良い
  * reorderしたくない場合は空行いれる
