# Terraform

## Usage

基本はこれ。

```sh
terraform init

terraform plan

terraform apply
```

* plan
  * state fileしかみないのでapplyしたらalready existsとか起きる

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

# formatの適用
terraform fmt -recursive [-check]

# validation
# 再帰的でないので、directory単位で適用する必要がある
terraform validate
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

hclの設定file, 実IDがあるstate, 実際のinfra。この3つが構成要素。importはhcl, 実際のinfraがある場合にstate fileを作成する処理といえる  

第２引数のIDは実際のinfraを識別するためのID。  
IDになにが必要かはresourceごとに違うので、documentをみる。


```sh
# module側で宣言されているresource
terraform import module.xxx.vault_audit.stdout yyy
```

* importしたいresourceがmodule側で宣言されている場合は先頭にmoduleつけて参照する


## 参考

[Terraform職人2020](https://qiita.com/minamijoyo/items/3a7467f70d145ac03324#terraformlockhcl)
