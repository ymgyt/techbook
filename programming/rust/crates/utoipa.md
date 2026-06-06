# utoipa

* openapiを出力する

## 導入までの流れ

1.  depsに追加

```toml
[dependencies]
utoipa = { version = "5.4.0", default-features = false, features = ["axum_extras", "chrono", "uuid", "url", "macros", "yaml"] }
```

2. handlerにannotation

```rust

#[derive(Debug, Deserialize, utoipa::ToSchema)]
#[serde(tag = "detail-type")]
pub enum SubscribedEvent {
  /* ... */
}

#[utoipa::path(
    post,
    path = "/aws/eventbridge",
    context_path = "/webhook",
    operation_id = "handle_aws_eventbridge_event",
    tag = "aws",
    request_body = SubscribedEvent,
    responses(
        (status = 204, description = "イベントを正常に処理"),
        (status = 401, description = "認可に失敗"),
    )
)]
pub async fn handler(
    event: SubscribedEvent,
) -> StatusCode { todo!() }
```

3. 生成処理

```rust
use utoipa::OpenApi;

#[derive(OpenApi)]
#[openapi(
  paths(crate::path::to::handler))]
struct ApiDoc;

fn main(self) -> anyhow::Result<()> {
    let api = ApiDoc::openapi();
    let yaml = api.to_yaml()?;
    println!("{yaml}");
    Ok(())
}
```
