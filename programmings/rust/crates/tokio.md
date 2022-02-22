# Tokio

## Recipe

### sleep

```rust
let interval = tokio::time::Duration::from_secs(1);
tokio::time::sleep(interval).await;
```

### setup runtime

```rust
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
```

### `try_join!`

複数のfeatureをconcurrentに実行する。FutAが`Poll::Pending`返したら、FutBを`poll`する。 
parallelにしたければ、`tokio::spawn()`をjoinするようにする。

```rust
async fn fetch_thing(name: &str) -> Result<()> {
    // ...
}

let res = tokio::try_join!(fetch_thing("first"), fetch_thing("second"));

match rest {
    Ok((first, second)) => {
        // do something...
    }
    Err(err) => {
        println!("error: {}", err);
    }
}

```

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
