# Auth

## RBAC

Role Based Access Control

### Role

* namespacedなresource
* どのresourceに対してなにができるかを定義する
* 誰がについては規定していない
  * RoleBidingが担う

### RoleBinding

* RoleとUser/Groupに紐づける

### ClusterRole

* admin用にnamespaceに限定されない


## Principalの管理

* KubernetesはUserを管理しない
* Userを表現するresourceはない

## Authentication

Api serverがrequestをhandleする際に設定された方法で認証する

## ServiceAccount

* 人間ではなくapplicationを表現するprincipal
* Roleのbinding対象
* Cluster内部のapplicationだけでなく外部(CI/CD,provisioning)に存在するapplicationを表す場合もある

## Api Serverの処理の流れ

1. Api ServerにRequestがくる
  * Authenticateする
2. Authorization
  * role,cluster-role,bindingを確認
