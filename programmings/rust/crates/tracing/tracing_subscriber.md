# tracing subscriber

## features

```toml
[dependencies]
tracing-subscriber = { version = "0.3.17", features = ["smallvec", "fmt", "ansi", "std", "env-filter", "time"], default-features = false }
```

* default-featuresはtracing-logの互換処理が入っているので切っている

## build subscriber

```rust
// Configure tracing_subscriber.
fn init_tracing(opts: &cli::TracingOptions) {
    use tracing_subscriber::{
        filter::EnvFilter, fmt, layer::SubscriberExt, util::SubscriberInitExt as _, Registry,
    };

    Registry::default()
        .with(
            fmt::Layer::new()
                .with_ansi(true)
                .with_timer(fmt::time::UtcTime::rfc_3339())
                .with_file(false)
                .with_line_number(false)
                .with_target(true),
        )
        .with(
            EnvFilter::try_from_default_env()
                .or_else(|_| EnvFilter::try_new("info"))
                .unwrap(),
        )
        .init();
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

### Envfilterをglobalにしない

```rust
fn init_tracing() {
    use syndapi::serve::layer::audit;
    use tracing_subscriber::{
        filter::EnvFilter, fmt, layer::SubscriberExt, util::SubscriberInitExt as _, Registry,
    };

    Registry::default()
        .with(
            fmt::Layer::new()
                .with_filter(
                    EnvFilter::try_from_default_env()
                        .or_else(|_| EnvFilter::try_new("info"))
                        .unwrap(),
                ),
        )
        .with(audit::layer())
        .init();
}
```

* `FmtLayer`に`with_filter()`でEnvFilterをつけるとひとつ下のAuditLayerは影響をうけない
* Fmt,Env,Auditをそれぞれ`with()`でつなげると下にあってもEnvFilterの影響をうける(global)になるので注意
