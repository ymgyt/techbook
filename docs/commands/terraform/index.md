# Terraform

## Usage

### plan & apply

基本はこれ。

```console
terraform init

terraform plan

terraform apply
```


## Install

sourceをcloneしてきて指定のversionをcheckoutしてinstallする。

```console
git clone https://github.com/hashicorp/terraform.git
cd terraform
git checkout <version>
go install
terraform version
```

## Expressions

### `for`


`for <assign_var> in <iterator> : <expression>` という感じ。

```terraform
# listのiterate
[for s in var.list : upeer(s)]
        
# enumerate        
[for i, v in var.list : "${i} is ${v}"] 
        
# mapのiterate
[for k, v in var.map : length(k) + length(v)]

# filter
[for s in var.list : upper(s) if s != ""]
```

mapを出力することもできる。  `for`を囲む記号でresult typeを制御する。

```terraform
{for s in var.list : s => upper(s)}

# { 
# foo = "FOO"
# bar = "BAR"
# }
```

## Resource

### Meta Arguments

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

## 参考

[Terraform職人2020](https://qiita.com/minamijoyo/items/3a7467f70d145ac03324#terraformlockhcl)
