# tracing

## logging

```rust
info!(%url, content_type = ?res.headers().get("content-type"), "Got a response!");
```

`name = %value`はvalueの`Display`を利用する、`name = ?value`は`Debug`を利用する。  
`name`と`value`が同じ場合は、`%value`と書ける。

## `#[tracing::instrument]`

```rust
#[tracing::instrument(
  name = "foo_xxx", // 指定しないと関数名
  level = "DEBUG",     // INFO, WARN, ... case insensitive
  skip(self, input),       // input fieldをskipする
  skip_all,         // すべてskipする 
  fields(bar = input.xxx) // 関数の最初で評価されるので引数が見える
  err, // Result<T,E>の場合でErrでerror!が使われる
  err(Display),
  err(Debug), // errどの実装つかうか制御できる
)]
async fn foo(&self, input: Input) -> Result<(), Error> { /* ... */ }
```

## span

### 作成後にfieldの値をset

```rust
use tracing::{trace_span, field};

// 作成時にわからない場合は、field::Emptyをsetしておく
let span = trace_span!("my_span", parting = field::Empty);

// あとでsetできる
span.record("parting", "goodbye world!");

// spanの参照がない場合は
tracing::Span::current().record("parting", "foo");
```

* 作成時に宣言されていないfieldにはrecordできない
  * `foo = field::Empty`をsetしておく
* 何回でもrecordできる
