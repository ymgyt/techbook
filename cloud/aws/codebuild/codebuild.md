# CodeBuild

## Pricing

* buildを送信?してからbuild終了までの時間を分単位切り上げ

### 1分あたり

| Instance type    | Memory  | vCPU | Linux per min |
|------------------|---------|------|---------------|
| general1.large   | 15 GB   | 8    | USD 0.02      |
| general1.xlarge  | 72 GiB  | 36   | USD 0.1002    |
| general1.2xlarge | 144 GiB | 72   | USD 0.25      |


## Cache

* S3とLocalがある

### Local Cache

* `LOCAL_DOCKER_LAYER_CACHE`でdockerのcacheを利用できる

```hcl
resource "aws_codebuild_project" "main" {
  # ...
  cache {
    # https://docs.aws.amazon.com/ja_jp/codebuild/latest/userguide/build-caching.html
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }
```
