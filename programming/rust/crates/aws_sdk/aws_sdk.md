# AWS SDK

## Clientのconstruction

1. `SdkConfig` の生成
  * regionやretry等の汎用的な設定

```rust
use aws_config::{retry::RetryConfig, BehaviorVersion, SdkConfig};

async fn load_sdk_config() -> SdkConfig {
    aws_config::defaults(BehaviorVersion::v2024_03_28())
        .region(REGION)
        .retry_config(RetryConfig::standard().with_max_attempts(3))
        .load()
        .await
}
```

2. `Client` の生成
  * `SdkConfig` で設定できないservice特有の設定はここで設定する

```rust
let config = load_sdk_config().await;
let config = aws_sdk_foo::config::Builder::from(&config)
    .some_service_specific_setting("value")
    .build();

let client = aws_foo_s3::Client::from_conf(config);
```

### Credentialの設定

* `Config::builder().credential_provider()`でcredentialの取得実装を渡せる
* `ProvideCredentials`の実装は`aws_config`から取得できる


SSOを利用したcredentialの設定  
`~/.aws/config`の`[profile foo]`を参照する想定

```rust
fn foo() {
  let cloudtrail_client = {
      // Load aws credentials from given profile
      let credential_provider =
          aws_config::profile::ProfileFileCredentialsProvider::builder()
              .profile_name("foo")
              .build();

      let cloudtrail_config = aws_sdk_cloudtrail::config::Config::builder()
          .region(region)
          .credentials_provider(credential_provider)
          .build();

      aws_sdk_cloudtrail::Client::from_conf(cloudtrail_config)
  };
}
```
