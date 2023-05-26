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

## Import

```sh
# module側で宣言されているresource
terraform import module.xxx.vault_audit.stdout yyy
```

* importしたいresourceがmodule側で宣言されている場合は先頭にmoduleつけて参照する

## Input

参照するresource側の定義

```hcl
provider "vault" {
  address               = var.vault_endpoint
}

variable "vault_endpoint" {
  type        = string
  description = "vault endpoint for terraform provisioning"
}
```

### tf command引数で渡す

`terraform plan -var=vault_endpoint=xxx`のように`-var=KEY=VALUE`で渡せる


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

## Versionの指定


```hcl
terraform {
  required_version = ">= 1.4.6"

  required_providers {
    vault = {
      version = ">= 3.15.2"  
    }
  }
}
```


* `main.tf`に書く
* `terraform version`で現在のprovider含めたversionがわかる
* version constraintsの書き方はdoc参照
  * https://developer.hashicorp.com/terraform/tutorials/configuration-language/versions#terraform-version-constraints
  * `>= 1.2.3`は1.2.3よりgrater
  * `~>` はpatchのみあげられる


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
