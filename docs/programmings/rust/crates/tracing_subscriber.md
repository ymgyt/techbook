# tracing subscriber

## build subscriber

```rust
fn init_logger(verbose: u8) -> Result<()> {
    tracing_subscriber::FmtSubscriber::builder()
        .with_target(true)
        .with_timer(tracing_subscriber::fmt::time::ChronoLocal::rfc3339())
        .with_env_filter(match verbose {
            0 => "app=info",
            1 => "app=debug,warp=debug,reqwest=debug",
            2 => "app=trace,warp=trace,reqwest=debug",
            _ => "trace",
        })
        .try_init()
        .map_err(|e| anyhow!(e))
}
```
