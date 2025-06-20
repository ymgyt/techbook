# serde

**ser**ializing and **de**serializingからとってきている。


## model定義

```rust
use serde::Serialize;
use chrono::{DateTime, Utc};

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct AppDescriptor {
    // jsonではtypeに
    #[serde(rename = "type")]
    typ: String, 
    
    key: String,
    
    // baseUrlになる
    base_url: String, 
    
    // RFC3339型はこれで表現できる
    participated_on: DateTime<Utc>,

    // Deserialize時にfieldがない場合はDefault::default()が呼ばれる
    // Optionの場合はNone
    #[serde(default)]
    retries: Option<usize>,

    // Noneのときはfieldがjsonにはいらなくなる
    #[serde(skip_serializing_if = "Option::is_none")]
    vendor: Option<String>,
    
    // serialize/deserialize時にそれぞれ
    // humantime_serde::serialize()
    // humantime_serde::deserialize()
    // が呼ばれる
    #[serde(with = "humantime_serde")]
    slow_timeout: std::time::Duration,

    #[serde(deserialize_with = "de_func")]
    foo_timeout: std::time::Duration,
}
```

* `rename_all`, `rename`
  * `lowercase`, `UPPERCASE`, `PascalCase`, `camelCase`
  * `snake_case`, `kebab-case`, `SCREAMING_SNAKE_CASE`

### enum

```rust
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "camelCase", rename_all_fields = "camelCase")]
pub( enum Policy {
    ChannelBase {
        allowed_channels: Vec<SlackChannelId>,
    },
    UserBase {
        allowed_users: Vec<SlackUserId>,
    },
    UserRoleBase {
        allowed_roles: Vec<Role>,
    },
    NoAuthorization,
}
```

* `rename_all`と`rename_all_fields`を指定しないとすべてに適用されない

## http_serde_ext

型にSerialize等がderiveされたいない場合に変換処理を定義した外部のmodule(crate)を利用できる

```rust
use http::Uri;
use serde::{Deserialize, Serialize};
#[derive(Deserialize)]
struct DeviceAuthorizationResponse {
    #[serde(with = "http_serde_ext::uri")]
    verification_uri: Uri,
    #[serde(with = "http_serde_ext::uri::option")]
    verification_uri_complete: Option<Uri>,
}
```

* `http::Uri`にderiveがないので`http_serde_ext`を利用する

## Custom deserialization

### Optional duration

* `30s`をDurationにしたい

```rust

#[derive(Debug, Serialize, Deserialize)]
pub struct ApiEntry {
    #[serde(default, deserialize_with = "config::parse_duration_opt")]
    timeout: Option<Duration>,
}

pub(crate) fn parse_duration_opt<'de, D>(deserializer: D) -> Result<Option<Duration>, D::Error>
where
    D: Deserializer<'de>,
{
    match Option::<String>::deserialize(deserializer)? {
        Some(duration) => match humantime::parse_duration(&duration) {
            Ok(duration) => Ok(Some(duration)),
            Err(err) => Err(serde::de::Error::custom(err)),
        },
        None => Ok(None),
    }
}
```

## Deserialize

```rust
pub trait Deserialize<'de>: Sized {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: Deserializer<'de>;

pub trait Visitor<'de>: Sized {
    type Value;

    /* Show 28 methods */
}
```
