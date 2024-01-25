# tower

## ServiceBuilder

```rust
use axum::{
    error_handling::HandleErrorLayer,
    http::{header::AUTHORIZATION, StatusCode},
    middleware,
    routing::{get, post},
    BoxError, Extension, Router,
};
use tokio::net::TcpListener;
use tower::{limit::ConcurrencyLimitLayer, timeout::TimeoutLayer, ServiceBuilder};
use tower_http::{
    cors::CorsLayer, limit::RequestBodyLimitLayer, sensitive_headers::SetSensitiveHeadersLayer,
};

/// Start api server
pub async fn serve() -> anyhow::Result<()> {

    let service = Router::new()
        .layer(
            ServiceBuilder::new()
                .layer(SetSensitiveHeadersLayer::new(std::iter::once(
                    AUTHORIZATION,
                )))
                .layer(trace::layer())
                .layer(HandleErrorLayer::new(handle_middleware_error))
                .layer(TimeoutLayer::new(Duration::from_secs(20)))
                .layer(ConcurrencyLimitLayer::new(100))
                .layer(RequestBodyLimitLayer::new(2048))
                .layer(CorsLayer::new()),
        )

    axum::serve(listener, service).await?;
    Ok(())
}

async fn handle_middleware_error(err: BoxError) -> (StatusCode, String) {
    if err.is::<tower::timeout::error::Elapsed>() {
        (
            StatusCode::REQUEST_TIMEOUT,
            "Request took too long".to_string(),
        )
    } else {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("Unhandled internal error: {err}"),
        )
    }
}
```

* towerのmiddlewareはerrorを返すが、axumのmiddlewareはerrorを返さない(Infallible)であることを期待されている
* HandleErrorLayerでerrorをstatus codeに変換する処理をいれるとtowerのmiddlewareを使える
* tower_httpはerrorではなくresponseを返しているので特になにもしなくても組み込める

### TraceLayer

```rust
use tower_http::trace::HttpMakeClassifier;
use tracing::Level;

#[derive(Clone)]
pub struct MakeSpan;

impl<B> tower_http::trace::MakeSpan<B> for MakeSpan {
    fn make_span(&mut self, request: &axum::http::Request<B>) -> tracing::Span {
        // headerとhttp versionを省略している
        tracing::span!(
            Level::INFO,
            "http",
            method = %request.method(),
            uri = %request.uri(),
        )
    }
}

#[derive(Clone)]
pub struct OnRequest;

impl<B> tower_http::trace::OnRequest<B> for OnRequest {
    fn on_request(&mut self, _request: &axum::http::Request<B>, _span: &tracing::Span) {
        // do nothing
    }
}

pub fn layer() -> tower_http::trace::TraceLayer<
    HttpMakeClassifier,
    MakeSpan,
    OnRequest,
    tower_http::trace::DefaultOnResponse,
> {
    tower_http::trace::TraceLayer::new_for_http()
        .make_span_with(MakeSpan)
        .on_request(OnRequest)
        .on_response(tower_http::trace::DefaultOnResponse::default().level(Level::INFO))
}
```

* on_response, on_failure系は判定ロジックが結構複雑なので自分で実装しづらい
