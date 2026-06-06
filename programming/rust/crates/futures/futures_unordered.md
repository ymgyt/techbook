# FuturesUnordered

* 複数のfutureのpollをまかせられる
* どれか完了したfutureの結果を取得できる
* 現在実行中のfutureを管理できるので、同時実行数の制御を行える
* 内部的にはfutureをlink listで管理しているらしい

```rust
use std::time::Duration;
use tokio::time::sleep;

// Define the async functions that return a String.
async fn task_one() -> String {
    sleep(Duration::from_secs(3)).await;
    "Task one completed".to_owned()
}
async fn task_two() -> String {
    sleep(Duration::from_secs(1)).await;
    "Task two completed".to_owned()
}
async fn task_three() -> String {
    sleep(Duration::from_secs(2)).await;
    "Task three completed".to_owned()
}
```

実行するtaskのmock

```rust
use futures::stream::FuturesUnordered;
use futures::StreamExt;
use std::pin::Pin;
use std::future::Future;

#[tokio::main]
async fn main() {
    // 型は同じでなければいけないのでdynamic traitでeraceする
    let mut tasks = FuturesUnordered::<Pin<Box<dyn Future<Output = String>>>>::new();

    // tokio::spawnを実行する必要はない
    // pushするとpollされる
    tasks.push(Box::pin(task_one()));
    tasks.push(Box::pin(task_two()));
    tasks.push(Box::pin(task_three()));

    // Unorderedなのでpushした順番と結果の取得は関係しない
    while let Some(result) = tasks.next().await {
        println!("{}", result);
    }
}
```

## 参考

* [FuturesUnordered: An Efficient Way to Manage Multiple Futures in Rust](https://betterprogramming.pub/futuresunordered-an-efficient-way-to-manage-multiple-futures-in-rust-a24520abc3f6)