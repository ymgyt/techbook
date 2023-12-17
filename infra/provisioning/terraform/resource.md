# Terraform Resource

## Meta Arguments

#### `for_each`

`each`にiterateしている情報が入っている。

```terraform
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}
```

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
  }
}
```

## Data Resource

Terrafromの外の世界から情報を取得して、terraformで利用できるようにする手段。  
readしか実装していない。
