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

```rust
use xxx::{cli, env::LOG_DIRECTIVE};
use tracing_subscriber::util::SubscriberInitExt;

// Configure tracing_subscriber.
fn init_tracing(opts: &cli::TracingOptions) {
    // Set default logging directive if not specified.
    if std::env::var(LOG_DIRECTIVE).is_err() {
        std::env::set_var(LOG_DIRECTIVE, "lawgueops=debug,info");
    }

    use tracing_subscriber::{filter, fmt, layer::SubscriberExt, Registry};
    Registry::default()
        .with(
            fmt::Layer::new()
                .with_ansi(opts.ansi)
                .with_timer(fmt::time::UtcTime::rfc_3339())
                .with_file(opts.source_code)
                .with_line_number(opts.source_code)
                .with_target(true),
        )
        .with(filter::EnvFilter::from_env(LOG_DIRECTIVE))
        .init();
}
```
