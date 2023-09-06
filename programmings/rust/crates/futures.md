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


  ### `unfold()`

  状態を更新しながら、Itemを返したい

```rust
use futures::stream::{self, StreamExt};

let stream = stream::unfold(0, |state| async move {
    if state <= 2 {
        let next_state = state + 1;
        let yielded = state  * 2;
        Some((yielded, next_state))
    } else {
        None
    }
});

let result = stream.collect::<Vec<i32>>().await;
assert_eq!(result, vec![0, 2, 4]);
```

* 処理の中で、stateの更新とItemとして返す値を計算する
* Noneを返すとStreamは終了
* futuresの世界をstreamの世界にしたい場合に便利