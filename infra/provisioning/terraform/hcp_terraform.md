# HCP Terraform

* `app.terraform.io`
* Hashicorpが運営しているcloud service
* stateをHCP terraform上で保持できる
* terraformの実行をhcp上で行うこともできそう

## 登場人物

Organization > Project > Workspace

* Organization
* Project
  * 複数のworkspaceをもつ
* Workspace
  * terraformのstateを保持する
  * Project間で移動できるらしい

## 認証

* `terraform login`
  * localにcredential情報が保存される
* `TF_TOKEN_app_terraform_io`
  * CIでは環境変数にtokenをいれておくと認証が通る

* backendは`cloud` 

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
