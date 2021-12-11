# `std::thread`

## `Result`

`std::thread::Result<T>`は以下のように定義されている。
```rust
pub type Result<T> = Result<T, Box<dyn Any + Send + 'static>>;
```

* `dyn Any`なので、`Result::Err` variantにおいて、情報としてはなにも保証されていない
* `panic!()` マクロの引数が渡されるので`Any`になっている。
