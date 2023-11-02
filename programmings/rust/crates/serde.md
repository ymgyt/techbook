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
}
```

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
