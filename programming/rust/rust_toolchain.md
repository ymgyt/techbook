# rust-toolchain

rootに`rust-toolchain.toml`を置く

```toml
[toolchain]
channel    = "1.79.0"
components = [
  # cargo-llvm-cov
  "llvm-tools-preview", 
  # rust-analyzerがrust-srcを必要とする
  "rust-src", 
  "rust-analyzer"
]
profile    = "default"
```

* projectで利用するversionを指定できる
