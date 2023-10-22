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
  }
}
```

* `create_before_destroy`
  * 原則はdelete,createだが、他のresourceに参照されている等で消せない場合がある。指定するとcreateしてからdeleteされる
* `prevent_destroy`
  * 削除されることを防ぐ。
  * 意図的に削除したい場合はまずfalseを設定する

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
