# `thiserror`

* `std::error::Error`をimplしてくれる

## Example

### Enum

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum CacheError {
    #[error("io error")]
    Io(#[from] std::io::Error),
    
    Io2 {
        #[from]
        source: std::io::Error,
        backtrace: Backtrace,
    },
    
    #[error("custom a error name:{name}")]
    CustomA {
        name: String,
    },
    
    #[error(transparent)]
    Other(#[from] anyhow::Error)
}
```

* `#[error()`で`std::fmt::Displayを実装できる
  * `#[error("{var}"]` で`self.var`を参照する

* `#[from]`を指定すると`From`が実装される
  * `#[from]`を指定する場合、そのfieldとbacktrace以外のfieldは存在できない
  * 自動的にsourceになる

* `source()`の実装を`#[source]で指定できる
  * これはenumではなくstructで定義するerror用?
  * fiedld名がsourceだと`#[source]`と同じ
  * source がloggingに含まれるから、loggingの実装次第
    * 確実に含めたければ、`#[error()]`に含める必要がある
      * ただし、重複してloggingされる可能性はある

*`#[error(transparent)]`を指定すると`source()`と`Display`の実装がdelegateされる
  * なので、`#[error("msg")]`のように指定しなくて良い


### struct

```rust
#[error("`{call}` failed")]
pub struct SyscallError {
    /// The name of the syscall which failed.
    pub call: &'static str,
    /// The [`io::Error`] returned by the syscall.
    #[source]
    pub io_error: io::Error,
}
```
