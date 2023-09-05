# AWS SDK

## Clientのconstruction

* 各ServiceのClientは共通で`SdkConfig`から生成できる
* Serviceごとに`Config`を定義しており、`Client::from_conf()`でも生成できる

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