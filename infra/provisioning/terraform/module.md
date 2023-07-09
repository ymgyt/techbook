# Terraform Module

* `.tf` fileを含んだdirectoryがterraformからmoduleとして扱われる
* moduleの中でmodule作る場合は`./modules`を作る

## Moduleの利用

利用側

```hcl
module "vault_dev" {
  source = "../../modules/vault"
}
```

* `main.tf`等でmodule resourceで参照する


## Output

module利用側が参照できる値。

module側

```hcl
output "my_output" {
  value = resource.xxx.yyy.id
}
```

* `output`を定義する
* 定義するfileは`output.tf`が一般的

参照側

```hcl
resource "xxx" "yyy" {
  module.xxx.my_output
}
```

* `module.<module_name>.<output_name>`で参照する


## 参照

https://developer.hashicorp.com/terraform/language/modules/develop/structure