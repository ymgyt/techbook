# rustfmt

## `rustfmt.toml`

```toml
# editionが指定できるようになった(2024から)
style_edition = "2024"

max_width = 130

# useのまとめ方
imports_granularity = "Crate"

# useをstd/thirdparty/selfに分類する
group_imports = "StdExternalCrate"

unstable_features = true
```

* optionごとにstable/unstableがあり、unstableを利用するために`unstable_features=true`を指定している。
  * `cargo +nightly fmt`で適用する。
