# mockall

1. mockしたいtraitにannotateする

```rust
#[cfg_attr(test, mockall::automock)]
trait SubscribeFeed {
    async fn subscribe_feed(&self, input: SubscribeFeedInput) -> Result<types::Feed, SyndApiError>;
}
```

2. mock objectを生成して、期待値をencodeする

```rust

```
