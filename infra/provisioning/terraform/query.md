# Terraform query

1. `.tfquery.hcl` fileをroot moduleに作る
2. list blockを定義する

  ```hcl
  list "aws_instance" "foo" {
    # ...
  }
  ```
3. `terraofmr query`を実行する
  * `terraform query -generate-config-out=generated.tf`


## list block

* `list "<TYPE>" "<LABEL>"`

```hcl
list "aws_instance" "prod" {
  provider = aws
  limit = 50
  config {
    region = "us-east-2"
    filter {
      name   = "tag:Name"
      values = ["prod-*", "staging-*"]
    }
    filter {
        name = "instance-state-name"
        values = ["running"]
    }
  }
}
```

* `provider` 必須
* configはprovider依存
* `include_resource` :よくわかってない
* `limit`: defualt 100
