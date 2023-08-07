# Terraform Module

* `.tf` fileを含んだdirectoryがterraformからmoduleとして扱われる
* moduleの中でmodule作る場合は`./modules`を作る

## Moduleの利用

利用側

```hcl
module "vault_dev" {
  source = "../../modules/vault"

  input_1 = "xxx"
  input_2 = 100
}
```

* `main.tf`等でmodule resourceで参照する

## Moduleの定義

1. module用のdirectoryを作成する
2. `main.tf`, `variables.tf`, `outputs.tf`を作成する

### Providerの定義

moduleで利用するproviderを定義する

```hcl
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.25"
    }
  }
}
```

例えば、moduleでgithub resourceを作成する場合

### Moduleのinput

`variables.tf`に以下のようにmoduleに必要なinputを定義する

```hcl
variable "name" {
  type        = string
  description = "name"
  nullable    = false
}
```


## Moduleのoutput

moduleの中で作成したresourceは利用側から見えない。
みせたい値はあらかじめmodule側がoutputとして明示的に定義しておく必要がある。

module側

```hcl
output "my_output" {
  value = resource.xxx.yyy.id
}
```

参照側

```hcl
resource "xxx" "yyy" {
  module.xxx.my_output
}
```

* `module.<module_name>.<output_name>`で参照する


## 参照

https://developer.hashicorp.com/terraform/language/modules/develop/structure