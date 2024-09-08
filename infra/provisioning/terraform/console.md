# terraform console

* 現在のstateに対して、interactiveにやりとりできる

`variables.tf`に定義してある変数に対して

```hcl
variable "apps" {
  type = map(any)
  default = {
    "foo" = {
      "region" = "us-east-1",
    },
    "bar" = {
      "region" = "eu-west-1",
    },
    "baz" = {
      "region" = "ap-south-1",
    },
  }
}
```

expressionを試せる

```sh

> { for key, value in var.apps : key => value if value.region == "us-east-1" }
{
  "foo" = {
    "region" = "us-east-1"
  }
}
```
