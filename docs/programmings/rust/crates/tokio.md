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


### test

```rust
#[test]
fn test_case() {
    tokio_test::block_on(async move {
        // test logic...
    })
}
```
