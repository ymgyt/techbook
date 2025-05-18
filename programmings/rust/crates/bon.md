# Bon

```rust

use bon::Builder;

#[derive(Debug, Builder)]
#[builder(on(String, into))]
#[builder(start_fn = builder)] // default
#[builder(finish_fn = build)]  // default
pub struct ExecuteQueryInput {
    #[builder(name = db)]
    pub database: String,
    pub query: String,
    pub parameters: Option<Vec<String>>,
    #[builder(default = false)]
    pub skip_header_row: bool,
}
```

* Container
  * `#[builder(on(String,into))]` String型のmethod signatureに`Into<String>`を生やす

* Field
  * `#[builder(name = foo)]`: Builder methodに別名を指定できる
  * `#[builder(default)]`: 未指定時にDefaultを使う
    *`#[builder(default = expression)]`: 未指定時にexpressionを使う
