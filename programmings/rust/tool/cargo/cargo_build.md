# cargo build

## Reference

* [Better support of Docker layer caching in Cargo](https://hackmd.io/jgkoQ24YRW6i0xWd73S64A)
  * cargoの依存のdocker layer でcacheする際の問題について整理されている

* [cargo build --dependencies-only issue](https://github.com/rust-lang/cargo/issues/2644#issuecomment-613024548)

## Profile

```toml
[profile.release]
strip = "symbols" 
```

* `strip`
  * `none(false)`
  * `debuginfo`
  * `symbols(true)` debuginfo + symbol


### Default profile

* [Default profile](https://doc.rust-lang.org/cargo/reference/profiles.html#default-profiles)


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

[profile.release]
opt-level = 3
debug = false
split-debuginfo = '...'  # Platform-specific.
strip = "none"
debug-assertions = false
overflow-checks = false
lto = false
panic = 'unwind'
incremental = false
codegen-units = 16
rpath = false
```
