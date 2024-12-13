# GitHub Apps

## 概要

* Repositoryのeventをwebhookで外に連携する仕組み  
* Repository単位とOrganization単位がある


## OAuth appsとの違い

* 基本的にはprefer Apps
  * scopeがfine-grained
  * short lived


## Install

* RepoかOrgのOwner or Admin
* GitHub App mangager permissionsをgrant

## Develop

1. GitHub App を developer settings から作成する
2. 個人 or Org に Install する
  * Profile > Settings > Integrations > Applications > App > Configure の遷移先URLから install IDを取得できる
  * https://github.com/settings/installations/:installId


### App の認証の流れ

1. app id と secret_key でJWTを生成する
2. JWT + install id で install access token を取得する
  * install 時に指定したaccess できる repositoryのscope が対応する
3. request header に install accesstoken をのせる
