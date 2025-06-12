# serde_with

```rust
#[skip_serializing_none]
#[derive(Serialize)]
struct Data {
    a: Option<String>,
    b: Option<u64>,
    c: Option<String>,
    // Always serialize field d even if None
    #[serialize_always]
    d: Option<bool>,
}
```
