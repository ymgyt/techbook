# AWS SDK

## Clientのconstruction

* 各ServiceのClientは共通で`SdkConfig`から生成できる
  * `SdkConfig`はservice共通の設定

```rust
let sdk_config = aws_config::load_from_env().await;
let foo_client = aws_sdk_foo::Client::new(&sdk_config);
```

* Serviceごとに`Config`を定義しており、`SdkConfig`で設定できない事項はこれで対応する

```rust
let sdk_config = aws_config::load_from_env().await;
let config = aws_sdk_foo::config::Builder::from(&sdk_config)
    .some_service_specific_setting("value")
    .build();
let foo_client = aws_sdk_foo::Client::from_conf(&config)
```

## `SdkConfig`のconstruct

```rust
let sdk_config = aws_config::from_env()
    .region(Region::new("ap-northeast-1"))
    .load()
    .await;
```

* `aws_config::from_env().override().load()`
  * `aws_config::load_from_env()`がこれのhelper

### ServiceごとのConfig

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