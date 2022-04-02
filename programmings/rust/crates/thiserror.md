# `thiserror`

* `std::error::Error`をimplしてくれる

## Example

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

* `source()`の実装を`#[source]で指定できる
  * これはenumではなくstructで定義するerror用?
  * `#[from]`が暗黙的に仮定されるとあるが単純に生成できない気がする
  * default担っていれば良い?

*`#[error(transparent)]`を指定すると`source()`と`Display`の実装がdelegateされる
  * なので、`#[error("msg")]`のように指定しなくて良い
