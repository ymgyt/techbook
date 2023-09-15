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
// Configure tracing_subscriber.
fn init_tracing(opts: &cli::TracingOptions) {
    use tracing_subscriber::{filter, fmt, layer::SubscriberExt, Registry, util::SubscriberInitExt as _};

    Registry::default()
        .with(
            fmt::Layer::new()
                .with_ansi(opts.ansi)
                .with_timer(fmt::time::UtcTime::rfc_3339())
                .with_file(opts.source_code)
                .with_line_number(opts.source_code)
                .with_target(true),
        )
        .with(
            EnvFilter::try_from_default_env()
                .or_else(|_| EnvFilter::try_new("info"))
                .unwrap(),
        ).init();
}
```

`filter::Targets`の使い方

* top levelにcomposeするとglobal filterになる
* layerに`with_filter()`でcomposeするとper-layer-filterになる

```rust
fn init_tracing() {
    use tracing_subscriber::{filter::Targets, fmt, prelude::*, Registry};

    let filter: Targets = std::env::var("RUST_LOG")
        .as_deref()
        .unwrap_or("info")
        .parse::<Targets>()
        .unwrap()
        // Disable aws sso profile warning
        // like profile `sso-session ymgyt-sso` ignored because `sso-session ymgyt-sso` was not a valid identifier
        .with_target("aws_config::profile::parser::normalize", Level::ERROR);

    Registry::default()
        .with(fmt::layer().pretty())
        .with(filter)
        .init();
}
```