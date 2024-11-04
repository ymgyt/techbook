# Terraform Module

* `.tf` fileを含んだdirectoryがterraformからmoduleとして扱われる
* moduleの中でmodule作る場合は`./modules`を作る

## Moduleの利用

利用側

```hcl
provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}

module "vault_dev" {
  source = "../../modules/vault"

  # 必要ならproviderを指定できる
  # 指定しない場合はdefault(unaliased)のaws providerが暗黙的に渡される
  providers = {
    foo = foo.alias
    aws = aws.usw2
  }

  input_1 = "xxx"
  input_2 = 100
}
```

* `main.tf`等でmodule resourceで参照する

## Moduleの定義

1. module用のdirectoryを作成する
2. `main.tf`, `variables.tf`, `outputs.tf`を作成する

### Providerの定義

moduleが必要とするproviderのrequirementsを定義する

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

## Module Locals

rootを含むmoduleの中だけで利用できる変数

```hcl
locals {
  port = 80
  foo = "xxx"
}

resource "foo_bar" "baz" {
  attr = local.foo
}
```

* `locals` blockで定義する
* 参照は`local.foo`

## Moduleの相対path

defaultではterraformは相対pathをcwdで解決する。  
これはroot moduleでは直感通りだが、moduleだと意図に反する。  

* `path.module` これでmoduleのdirを参照できる

## Inline blockはつかわないほうがいい

```hcl
resource "aws_security_group" "alb" {
  ingress {
    # ...
  }
}
```

* resourceの中でさらにresourceを定義できる場合があるが、moduleでは利用しないほうがいい
  * module利用側がinlineされたresourceを別で定義しているとterraformの仕様でerrorになるらしい
  * 利用側で追加できない

## Local value

```hcl
locals {
  name = "foo"
}

resource "foo" "bar" {
  name = local.name
}
```


## 参照

https://developer.hashicorp.com/terraform/language/modules/develop/structure
