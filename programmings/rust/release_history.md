# Rust Release History

* [1.93.3](https://blog.rust-lang.org/2026/01/22/Rust-1.93.0/)
  * `*-linux-musl`が 1.2.5になった。DNS resolverの改善がなされたらしい

* [1.90.0](https://blog.rust-lang.org/2025/09/18/Rust-1.90.0/)
  * `x86_64-unknown-linux-gnu`でlld linkerがdefaultになった

* 1.88.0
  * let chains
    * 2024 editionが必要
  * cargoのgcがstable

* 1.81.0
  * [`core::error::Error`がstable](https://blog.rust-lang.org/2024/09/05/Rust-1.81.0.html#whats-in-1810-stable)
  * [sortの実装が変わった?](https://blog.rust-lang.org/2024/09/05/Rust-1.81.0.html#new-sort-implementations)
  * [`#[expect()]`が追加](https://blog.rust-lang.org/2024/09/05/Rust-1.81.0.html#expectlint)
  * [`fs::exists`](https://doc.rust-lang.org/stable/std/fs/fn.exists.html)
  * [`std::panic::PanicInfo`が`std::panic::PanicHookInfo`にrename](https://blog.rust-lang.org/2024/09/05/Rust-1.81.0.html#compatibility-notes)

* 1.74.0
  * Cargo.tomlにclippy(linter)を設定できるようになった
    * https://rust-lang.github.io/rfcs/3389-manifest-lint.html

