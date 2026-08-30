# Cargo Profile

* compiler settingsを変更する方法。  
  * https://doc.rust-lang.org/cargo/reference/profiles.html
* defaultでは`dev`,`release`,`test`,`bench`がある。
* `Cargo.toml`で指定できる

```toml
[profile.dev]
opt-level = 1
overflow-checks = false
panic = "abort"
```
* `opt-level`
  * `-C opt-level`に対応
  * `0`: no optimizations
  * `1`: basic optimizations
  * `2`: some optimizations
  * `3`: all optimizations
  * `s`: binary size optimization
  * `z`: binary size opt, loop vectorizationは無効
  
* `panic`
  * `unwind` stack のunwindを実行する
  * `abort`

* `debug`
  * DWARFの生成を制御
    * 詳細なDWARFはLLVM, arch依存
    * `-C debuginfo` を制御
  * `line-tables-only` : file,line関連の最低限
  * `none    | 0 | false`: DWARFを生成しない
  * `limited | 1`
  * `full    | 2 | true`: 完全なDWARF

* `strip`
  * `none    | false`
  * `symbols | true`
  * `debuginfo`


## Default profiles

### `dev`

```toml
[profile.dev]
opt-level = 0
debug = true
split-debuginfo = '...'  # Platform-specific.
strip = "none"
debug-assertions = true
overflow-checks = true
lto = false
panic = 'unwind'
incremental = true
codegen-units = 256
rpath = false
```
