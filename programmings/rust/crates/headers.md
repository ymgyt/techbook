# headers

http headerごとに専用の型を定義している

## Authorization

```rust
use http::HeaderMap;
use headers::{authorization::Bearer, Authorization, Header};

fn foo(headers: HeaderMap) {
    let auth = headers.get(Authorization::<Bearer>::name()).unwrap();
    let auth = Authorization::<Bearer>::decode(&mut std::iter::once(auth)).unwrap();
    let token = auth.token();
}
```

* Basic認証、Bearerがgenericになっている美しい定義
