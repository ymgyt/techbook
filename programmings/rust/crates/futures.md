# futures

## Stream

pinどめ

```rust
async fn foo<S>(s: S) 
  where S: Stream<Item = Result<String,_>> + 'static'
{
  let mut s = std::pin::pin!(s);

  while let Some(foo) = s.next().await.transpose()? {
    // handle...
  }
}

```

* `Stream::next()`を行うにはpinどめする必要がある。
  * pin projectとstd pinどちらがよいかわかっていない