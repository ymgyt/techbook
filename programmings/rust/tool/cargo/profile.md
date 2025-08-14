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
* `panic`
  * `unwind` stack のunwindを実行する
  * `abort`


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
