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

    // Noneのときはfieldがjsonにはいらなくなる
    #[serde(skip_serializing_if = "Option::is_none")]
    vendor: Option<String>,
}
```
