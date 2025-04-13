# Terraform Resource

## Lifecycle

全resource共通で、依存関連の指定

```hcl
resource "xxx" "foo" {
  lifecycle {
    create_before_destroy = true
    prevent_destroy = true

    ignore_changes = [
      some_field_to_ignore,
    ]

    precondition {
      condition     = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS Free Tier!"
    } 
    postcondition {
      condition     = length(self.availability_zones) > 1
      error_message = "You must use more than one AZ for high availability!"
    } 
  }
}
```

* `create_before_destroy`
  * 原則はdelete,createだが、他のresourceに参照されている等で消せない場合がある。指定するとcreateしてからdeleteされる
* `prevent_destroy`
  * 削除されることを防ぐ。全resourceに書ける
  * 意図的に削除したい場合はまずfalseを設定する
  * resource定義全体を削除したあとにapplyしたら消せるので万能ではない
* `ignore_changes`
  * terraform管理外で変更されてもterraformとしては無視する(planで差分が生じない)
* `precondition`
  * 調べる
* `postcondition`
  * 調べる
  
### Operation Timeout

Resourceの作成に時間がかかる場合がある。その際にtfのtimeoutを指定することができる。

```terraform
resource "aws_db_instance" "example" {
  # ...

  timeouts {
    create = "60m"
    delete = "2h"
    update = "30m"
  }
}
```

## Dynamic block

```hcl
variable "ingress_rules" {
  type = list(object({
    port        = number
    description = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 80
      description = "HTTP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      description = "HTTPS"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

```hcl
resource "aws_security_group" "main" {
  name = "main-sg"
  vpc_id = "<vpc-id>"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

* nested blockを動的に宣言する
* `content`
  * iteratorの変数名はdefaultではdynamic block 名になる


## Data Resource

Terrafromの外の世界から情報を取得して、terraformで利用できるようにする手段。  
readしか実装していない。


## `moved` block

```hcl
moved {
  from = aws_instance.a
  to   = aws_instance.b
}
```

* plan適用前に、state の `aws_instance.a` を `aws_instance.b` として扱う
  * あたかも初めから、`aws_instance.b` として定義したのと同じ状態になる
  * refactor(rename)とstateの整合性がとれる
* moved を利用しないと、`aws_instance.a` を destroyして、`aws_instance.b`がcreateされる

* 一度、moved が `terraform apply` されれば、`moved` は消せる
  * ただし、すべてのstateへのapplyが済んでいると確信できない限りは残しておくのが良い
