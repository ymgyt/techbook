# Axum Route

## 特定のrouteにだけlayer(middleware)を適用する

```rust
use axum::{
    routing::get,
    Router,
};
use tower_http::validate_request::ValidateRequestHeaderLayer;

let app = Router::new()
    .route("/foo", get(|| async {}))
    .route_layer(ValidateRequestHeaderLayer::bearer("password"));

// `GET /foo` with a valid token will receive `200 OK`
// `GET /foo` with a invalid token will receive `401 Unauthorized`
// `GET /not-found` with a invalid token will receive `404 Not Found`
```
