# Chrono

## 現在時刻

```rust
use chrono::{Utc,DateTime,Local};

// UTC
let now: DateTime<Utc> = Utc::now();

// Local
let local: DateTime<Local> = Local::now();
```

## TimeZone
`chrono_tz`に各種timezoneが定義してある。

```rust
use chrono_tz::Asia;
use chrono::Utc;

// jstへの変換
let jst = Utc::now().with_timezone(&Asia::Tokyo);
```

## 文字列表現

```rust
let rfc_3339 = chrono::Utc::now().to_rfc3339();
```

## 文字列のparse

```rust
let dt = chrono::DateTime::parse_from_rfc3339("2021-01-01T15:00:00+09:00")
```

## Unix Timestamp表現

```rust
chrono::Utc::now().timestamp()
chrono::Utc::now().timestamp_mills()
```

## Unix Timestampのparse

```rust
use chrono::{DateTime,Utc}

let dt: DateTime<Utc> = Utc.timestamp(1_5000_000_000,0);
```

## Durationを加える

```rust
use chrono::{Utc, Duration};

let d = Duration::hors(1);
let dt = Utc::now() + d;
```

## serde対応

```toml
[dependencies]

chrono = { version = "*", features = ["serde"]}
```
