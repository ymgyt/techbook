# Tokio

## Recipe

### sleep

```rust
async fn example() {
    let interval = tokio::time::Duration::from_secs(1);
    tokio::time::sleep(interval).await;
}
```

### setup runtime

```rust
async fn example() {
    tokio::runtime::Builder::new_multi_thread()
        .worker_threads(num_cpus::get())
        .on_thread_start(|| tracing::trace!("thread start"))
        .on_thread_stop(|| tracing::trace!("thread stop"))
        .enable_io()
        .enable_time()
        .build()
        .unwrap()
        .block_on(async {
            run().await;
        })
}
```

### `try_join!`

複数のfeatureをconcurrentに実行する。FutAが`Poll::Pending`返したら、FutBを`poll`する。 
parallelにしたければ、`tokio::spawn()`をjoinするようにする。

```rust
async fn fetch_thing(name: &str) -> Result<()> {
    // ...
}

async fn example() {
    let res = tokio::try_join!(fetch_thing("first"), fetch_thing("second"));

    match rest {
        Ok((first, second)) => {
            // do something...
        }
        Err(err) => {
            println!("error: {}", err);
        }
    }
}
```

### timeout

```rust
use tokio::time::timeout;
use tokio::sync::oneshot;

use std::time::Duration;

async fn example() {
    let (tx, rx) = oneshot::channel();

    // Wrap the future with a `Timeout` set to expire in 10 milliseconds.
    if let Err(_) = timeout(Duration::from_millis(10), rx).await {
        println!("did not receive value within 10 ms");
    }
}
```

* `Result<T, Elapsed>`にwrapされる

### `JoinSet`

同時に実行するfutureの数を制限したい場合に利用できる。

```
use tokio::time::{sleep, Duration};
use tokio::task::JoinSet;

#[tokio::main]
async fn main() {
    let max_concurrent = 2;
    let ids: Vec<u64> = (1..=10).into_iter().collect();
    let mut join_set = JoinSet::new();
    
    for id in ids {
        while join_set.len() >= max_concurrent {
            join_set.join_next().await.unwrap().unwrap();
        }
        join_set.spawn(my_bg_task(id));
    }   
  
    while let Some(output) = join_set.join_next().await {
        output.unwrap();
    }
}

async fn my_bg_task(id: u64) {
    todo!()
}
```
* `JoinSet::spawn()`すると内部的に`tokio::task::spawn()`される

### test

```rust
#[test]
fn test_case() {
    tokio_test::block_on(async move {
        // test logic...
    })
}
```

macroもある

```rust
#[tokio::test(flavor = "multi_thread", worker_threads = 1)]
async fn my_test() {
    assert!(true);
}

#[tokio::test]
async fn my_test() {
    assert!(true);
}
```

Cargo.toml
```toml
[dev-dependencies]
tokio = { version = "1", features = ["rt", "macros"], default_features = false }
```
