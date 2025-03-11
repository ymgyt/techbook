# Import

* 宣言されているresourceのstateを更新する処理。  
したがって、import前に対応する`resource "xxx" "yyy"`が必要。

* hclの設定file, 実IDがあるstate, 実際のinfra。この3つが構成要素。importはhcl, 実際のinfraがある場合にstate fileを作成する処理といえる  

* 第２引数のIDは実際のinfraを識別するためのID。  
IDになにが必要かはresourceごとに違うので、documentをみる。

* resourceによっては一度のimportで複数の関連するresourceを取得する
  * `terraform state list`で確認
  * 関連resourceも定義しておかないとplanで削除がでる


## Importの手順

1. import対象リソースをhclで宣言する
  * `aws_vpc.foo`とする
2. `terraform import aws_vpc.foo vpc-123456`でimportする
  * 引数の識別子はimport対象resourceによる
  * vpcの場合はvpc-id
3. `terraform state show aws_vpc.foo`でimportしたresourceのstateを確認する
4. stateの内容とあるべき設定にもとづいてresource定義を修正する
5. planが実行できる

## Moduleのimport

```sh
# module側で宣言されているresource
terraform import module.xxx.vault_audit.stdout yyy
```

* importしたいresourceがmodule側で宣言されている場合は先頭にmoduleつけて参照する


## import block

1. `import` blockを定義する
  * `id` importしたいresourceの識別子
    * なにをidとするかはresourceによって異なるのでdocをみる
  * `to` importしたstateが紐づく、resource

```hcl
import {
  id = "o-5x9fse2mec"
  to = aws_organizations_organization.ymgyt
}
```

2 `to`で指定したresourceにあるべき設定を書く
  * importは既存の設定からresource fileを更新してくれるわけではない(別のcommand)
  * resourceに記述する内容はimportに頼らず定義するかgenerateする

```hcl
resource "aws_organizations_organization" "ymgyt" {
  aws_service_access_principals = []
  enabled_policy_types          = []
  feature_set                   = "ALL"
}
```

3 `terraform plan`でimport blockに対応する設定fileを生成する
  * `terraform plan -generate-config-out=generated_resources.tf`
  * ここでdiffがでるまでresourceを更新できれば、applyが安全になると思う

4 `terraform apply`
  * これでresource,stateと実際のinfraが一致する

