# nextest

## 設定file

`.config/nestest.toml`に書く

```toml
[profile.ci]
# 失敗時のoutputをどこに出力するか。
# finalにしておくとCIのUIで見やすい
failure-output = "immediate-final"

# 失敗しても続ける。CIでは全ての結果が見たい。
fail-fast = false
```

## profile

* `cargo nextest run --profile ci`のようにprofileを指定できる。
  * 適用したい設定群を管理できる
