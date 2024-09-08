# Terraform backend

terraformのstate fileをどこに置くかの設定

## S3

```hcl
terraform {
  backend "s3" {
    bucket  = "terraform-state"
    key     = "path/to/terrafrom.tfstate"
    region  = "ap-northeast-1"
    profile = "my-profile"

    # lockする場合のdynamodb
    dynamodb_table = "dynamo_table_foo"
  }
}
```

通常は`main.tf`の`backend` blockに定義する。  

## HCP Terraform

```hcl

terraform {
  cloud {
    organization = "ymgyt"

    workspaces {
      name = "grafana"
    }
  }
}
```

* terraformのcloud上でstateを管理できる
* project > workspaceというモデルだが、projectの指定は不要らしい
* 認証
  * local `terraform login`
  * ci: `TF_TOKEN_app_terraform_io`にcloud上で発行したtokenを渡す

## Backendの設定をfileに切り出す

backendの設定はstateの数だけ重複してしまうのでfileに切り出せる。  

`config.s3.tfbackend`
```hcl
bucket = "terraform-state"
region = "ap-northeast-1"
profile = "my-profile"
```

```hcl
terraform {
  backend "s3" {
    key = "path/to/terraform.tfstate"
  }
}
```

```sh
# 設定fileの値を読んで、main.tfの定義とマージ
terraform init -backend-config=config.s3.tfbackend

# 設定をflagからも渡せる
terraform init -backend-config="bucket=foo"
```


* `terraform init -backend-config`で指定したfileのtop levelのkey valueがbackend blockの設定にmergeされる
  * mergeされた値は`.terraform` directoryに保持される

* 値を変えた場合は`-reconfigure`を付与する
  `terraform init -backend-config=./config.s3.tfbackend -reconfigure`
