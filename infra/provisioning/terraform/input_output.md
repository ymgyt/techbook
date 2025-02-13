# Terraform Input

参照するresource側の定義

```hcl
provider "vault" {
  address               = var.vault_endpoint
}

variable "vault_endpoint" {
  type        = string
  sensitive = false
  description = "vault endpoint for terraform provisioning"
  default = "default"
}

variable "files" {
  description = "desc"
  type = object({
    field_a = bool
    field_b = optional(string, "fallback")
  })
}
```

* `sensitive`で表示されるか制御できる
* `default`値をもてる
* 参照は`var.VAR_NAME`

### tf command引数で渡す

`terraform plan -var=vault_endpoint=xxx`のように`-var=KEY=VALUE`で渡せる

### 環境変数で渡す

* `export TF_VAR_variable_name=foo`
  * `TF_VAR_`の後に変数名指定して渡せる

### moduleに引数を渡す

```hcl
module "child_module" {
  source = "../../my-module"
  vault_endpoint = "http://localhost:1234"
}
```

* moduleに渡す際はargumentのように渡せる

## Example

### object

```hcl
variable object_example {
  description = "foo"
  type = object({
    tags = list(string)
    enabled = bool
  })

  default = {
    tags = ["a", "b"]
    enabled = false
  }
}
```

```sh
terraform plan -var object_example='{tags: ["x"], enabled: true}'
```

### Validation

```hcl
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free tier is allowed: t2.micro | t3.micro."
  }
}
```

* `validation` blockを定義できる

## Output

```hcl
output NAME {
  value = provider_type.id.attribute
  description = "foo"
  sensitive = true
  depends_on = xxx
}

# for_eachで作ったresourceをlistにする
output "worker_instance_ids" {
  value = [for x in aws_instance.worker : x.id]
}
```

* `depends_on`は通常必要ないが、依存関係を伝えなければいけない場合もあるらしい

* `terraform output [-json|-raw] var`で出力できるので、taskrunnerと連携できる

## Locals

```hcl
locals {
  foo = "foo"
}

# local.fooで参照
```

* local変数を定義できる
