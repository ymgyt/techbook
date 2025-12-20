# Remote State datasource

* 他のroot moduleのoutputをdata sourceとして参照できる
  * root moduleのoutputsだけ見える

## S3

remote 

```hcl
data "terraform_remote_state" "foo" {
  # 参照したいremoteのbackendと同じ値を使う
  backend = "s3"
  config = {
    bucket = "ymgyt-bucket"
    key    = "path/to/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

output "remote" {
  value = data.terraform_remote_state.foo.outputs.bar
}
```

remote 側の定義

```hcl

terraform {
  # ...
  backend "s3" {
    bucket = "ymgyt-bucket"
    key    = "path/to/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
```
