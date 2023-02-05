# tracing_futures 

```rust
use tracing_futures::Instrument;

let operation = async {
    // ...
};

operation
    .instrument(tracing::info_span!("operation=xxx"))
    .await
```
