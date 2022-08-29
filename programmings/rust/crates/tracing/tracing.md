# tracing

## logging

```rust
info!(%url, content_type = ?res.headers().get("content-type"), "Got a response!");
```

`name = %value`はvalueの`Display`を利用する、`name = ?value`は`Debug`を利用する。  
`name`と`value`が同じ場合は、`%value`と書ける。
