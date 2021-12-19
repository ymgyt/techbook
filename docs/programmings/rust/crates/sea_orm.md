# SeaORM

## Cargo.toml

```yaml
sea-orm = { version = "^0", features = ["sqlx-postgres", "runtime-tokio-rustls", "macros", "debug-print"], default-features = false}
```

database driverとasync runtimeをfeatureで制御する。

https://www.sea-ql.org/SeaORM/docs/install-and-config/database-and-async-runtime
