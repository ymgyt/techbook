# futures

## Re-export

```rust
pub use futures_core::future::Future;
pub use futures_core::future::TryFuture;
pub use futures_util::future::FutureExt;
pub use futures_util::future::TryFutureExt;
pub use futures_core::stream::Stream;
pub use futures_core::stream::TryStream;
pub use futures_util::stream::StreamExt;
pub use futures_util::stream::TryStreamExt;
pub use futures_sink::Sink;
pub use futures_util::sink::SinkExt;
pub use futures_io::AsyncBufRead;
pub use futures_io::AsyncRead;
pub use futures_io::AsyncSeek;
pub use futures_io::AsyncWrite;
pub use futures_util::AsyncBufReadExt;
pub use futures_util::AsyncReadExt;
pub use futures_util::AsyncSeekExt;
pub use futures_util::AsyncWriteExt;
```

## `FuturesExt`

* `left_future()`
  * `futures::Either`でwrapしてくれる
  * if等の分岐で違うfutureを実行したい場合に使える

```rust
use futures::future::FutureExt;

let x = 6;
let future = if x < 10 {
    async { true }.left_future()
} else {
    async { false }.right_future()
};

assert_eq!(future.await, true);
```

* `futures`がいくつかの`futurees_`をre-exportしている

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
* 困ったら`Stream::boxed()`でheapにpin止めできる


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

* paging する apiを`Stream`に変換する

```rust
impl ReportsApi for ReportsClient {
    fn list_drive_activities(
        &self,
        input: ListDriveActivitiesInput,
    ) -> impl Stream<Item = Result<Bytes, ReportsApiError>> {
        enum Phase {
            Requesting,
            Completed,
        }
        struct State {
            phase: Phase,
            client: ReportsClient,
            input: ListDriveActivitiesInput,
        }

        stream::unfold(
            State {
                phase: Phase::Requesting,
                client: self.clone(),
                input,
            },
            |mut state| async move {
                match state.phase {
                    Phase::Requesting => {
                        let mut item = state.client.get_drive_activities(&state.input).await;

                        // next page token を探すために json に decodeする
                        let mut page_token = None;
                        if let Ok(body) = item.as_ref() {
                            match serde_json::from_slice::<serde_json::Value>(body.as_ref()) {
                                Ok(value) => {
                                    if let serde_json::Value::String(next_page_token) =
                                        &value["nextPageToken"]
                                    {
                                        if !next_page_token.is_empty() {
                                            page_token = Some(next_page_token.clone());
                                        }
                                    }
                                }
                                Err(decode_err) => {
                                    item = Err(ReportsApiError::DecodeJson(decode_err));
                                }
                            }
                        }
                        match page_token {
                            Some(page_token) => state.input.page_token = Some(page_token),
                            None => state.phase = Phase::Completed,
                        }

                        Some((item, state))
                    }
                    Phase::Completed => None,
                }
            },
        )
    }
}
```

* 処理の中で、stateの更新とItemとして返す値を計算する
  * 関数としてはstateもreturnするが、次のpollで引数でもらえる
* Noneを返すとStreamは終了
* futuresの世界をstreamの世界にしたい場合に便利

### `StreamExt`

* `inspect`: streamのitemを途中でみたくなったら使える
  * `Iterator::inspect()`のstream版
  * TryStreamに`inspect_ok()`等の亜種がある

* `take_until()`: 引数にsignal handlingやshutdownのfutureを渡せる
  * stopping futureを評価してから、元streamがpollされるのか、順番わかっていないので調べたい。

* `fuse()`: 通常、`Stream::poll_next()`が`None`を返したら、次に`poll_next()`を読んではいけない。  
  * `None`を返しても繰り返し呼べる`Stream`はfusedと呼ばれ、このmethodでそのsemanticsを表現できる
