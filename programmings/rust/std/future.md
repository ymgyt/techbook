# future

* 一度`Poll::Ready`を返したfutureにpollしてはいけない。
  * `Ready`を返したあとにpollされたら`panic!`してよい
  * `Ready`を返したあとにもpollできるものをfused futureと呼ぶ

## 複数のfutureを実行する際の実装パターン

以下の点を考慮する必要がある
* `task::spawn`でparallelにするかどうか
* 結果の順番が重要かどうか
* すべての結果が必要かどうか
* どれかひとつでも失敗した場合に残りをキャンセルしたいかどうか


* `tokio::spawn()`してhandleをVecで管理する

```rust
async fn do() {
  let mut handles = Vec::new();
  for i in 1..5 {
    // do your work
    handles.push(tokio:;spawn(asymc move { i }));
  }

  let results = Vec::with_capacity(handles.len());
  for handle in handles {
    results.push(handle.await.unwrap());
  }
}
```
