# Bon

```rust

use bon::Builder;

#[derive(Debug, Builder)]
// intoの一括実装
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

    #[builder(skip = helper()]  
    pub inner: Inner,

    // fieldごとに指定もでいる
    #[builder(into)]
    pub name: Cow<'static,str>,
}

fn helper() -> Inner { todo!() }
```

* Container
  * `#[builder(on(String,into))]` String型のmethod signatureに`Into<String>`を生やす

* Field
  * `#[builder(name = foo)]`: Builder methodに別名を指定できる

  * `#[builder(default)]`: 未指定時にDefaultを使う
    *`#[builder(default = expression)]`: 未指定時にexpressionを使う

  * `#[builder(skip)]`
    * builderの対象外にできる
    * skipの引数で利用する処理(expression)を指定できる

  * Option<T>にOption<T>を渡したいときは、`maybe_field`がある
