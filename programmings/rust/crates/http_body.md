# http_body

## `Body` trait

```rust
pub trait Body {
    type Data: Buf;
    type Error;

    // Required method
    fn poll_frame(
        self: Pin<&mut Self>,
        cx: &mut Context<'_>,
    ) -> Poll<Option<Result<Frame<Self::Data>, Self::Error>>>;

    // Provided methods
    fn is_end_stream(&self) -> bool { ... }
    fn size_hint(&self) -> SizeHint { ... }
}
```

* HTTP Body streamの抽象model
* ただの`Stream<Bytes>`と違うのは、`tailers`を返しうること
  * `Frame`が実質、`Data`とtrailersのenum(layer)



## Memo

* hyperの`Body`との違いは
* trailersとは
* `Buf`と`Bytes`
* size_hintのusecase
* http-body-util
* AWS SDK Smithy
* `http_body_util::Limited<B>`
