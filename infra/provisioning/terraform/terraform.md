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

## Log

* `TF_LOG=debug terraform plan`
  * TRACE,DEBUG,INFO,...
  * `TF_LOG_PATH`でfile書き出しもできる

## Install

sourceをcloneしてきて指定のversionをcheckoutしてinstallする。

```console
git clone https://github.com/hashicorp/terraform.git
cd terraform
git checkout <version>
go install
terraform version
```

## 参考

[Terraform職人2020](https://qiita.com/minamijoyo/items/3a7467f70d145ac03324#terraformlockhcl)
