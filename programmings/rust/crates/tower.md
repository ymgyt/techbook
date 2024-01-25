# tower

## tower_http

```rust
use tower_http::{
    cors::CorsLayer, limit::RequestBodyLimitLayer, sensitive_headers::SetSensitiveHeadersLayer,
    timeout::TimeoutLayer,
};

async fn serve() {
  let service = Router::new()
      .route("/graphql", post(gql::handler::graphql))
      .layer(
          // applied top to bottom
          tower::ServiceBuilder::new()
              .layer(SetSensitiveHeadersLayer::new(std::iter::once(
                  AUTHORIZATION,
              )))
              .layer(RequestBodyLimitLayer::new(2048))
              .layer(trace::layer())
              .layer(TimeoutLayer::new(Duration::from_secs(15)))
              .layer(CorsLayer::new()),
      )
}

```

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
