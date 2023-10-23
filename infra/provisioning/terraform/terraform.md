# Terraform

## Usage

基本はこれ。

```sh
terraform init

terraform plan

terraform apply
```

```sh
# dotlangの出力
terraform dot

# outputの出力
terraform output

# 指定もできる
terraform output foo

# 削除
terraform destroy

# REPL
# 関数等をためせる
terraform console
```

* `terraform dot`で依存関係をvisualizeできる

### Workspace

```sh
# 表示
terraform workspace show
terraform workspace list

# 作成
terraform workspace new staging

# 変更
terraform workspace select
```

workspaceについてはstateを参照

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

宣言されているresourceのstateを更新する処理。  
したがって、import前に対応する`resource "xxx" "yyy"`が必要。

```sh
# module側で宣言されているresource
terraform import module.xxx.vault_audit.stdout yyy
```

* importしたいresourceがmodule側で宣言されている場合は先頭にmoduleつけて参照する


#### importとの違い

* dataはdestroyしても削除されない
* terraformの外でimportしたresourceを変更すると、apply時にhclの状態に戻そうとする

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



## 参考

[Terraform職人2020](https://qiita.com/minamijoyo/items/3a7467f70d145ac03324#terraformlockhcl)
