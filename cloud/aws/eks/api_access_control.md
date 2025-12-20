# API Access Control

## Authentication mode

Clusterには以下のいずれかのauthentication modeの設定がある。

* `aws-auth` ConfigMap (`CONFIG_MAP`)
  * 今までの方法
* ConfigMapとaccess entries(`API_AND_CONFIG_MAP`)
  * ConfigMapとaccess entriesは独立している
  * Access Entryが優先
* Access entries only(`API`)

  * access entries(api)の利用にはkubernetesのversionとeksのplatform versionが影響する
  * 確認するには`aws eks describe-cluster --name my-cluster --query 'cluster.{KubernetesVersion:": version, "PlatformVersion: platformVersion"}'`

  * 前提条件を満たすClusterの場合、Clusterを作成したIAM principalは自動的にaccess entriesに追加される

  * `API`を有効にすると、無効にはもどせない
    * `aws eks update-cluster-config --name my-cluster --access-config authenticationMode=API_AND_CONFIG_MAP`

* IAM PrincipalのARNとkubernetes上のgroupを紐付けられる
  * kubernetes上のgroupへの権限付与はRoleBinding等でkubernetes側でおこなう前提

* AWS側で、namespaceを指定するpolicyを定義して紐づけることもできる
  * これはIAM Policyとは別でIAM EKS Policyというリソース

* [公式Blog Handson](https://aws.amazon.com/blogs/containers/a-deep-dive-into-simplified-amazon-eks-access-management-controls/)

## Access Entry API

IAM Principalにkubernetesのroleを紐づけられるEKSのAPI。
config-mapでは管理主体がEKS内にあったが、EKSの外で管理できる

* Components
  * Access Entry
    * IAM PrincipalとAccess Policyの紐づけ
  * Access Policy

### Access Policy

* IAM Policyとは別のEKS独自のpolicy
* `aws eks list-access-policies`で確認できる

## Authentication flow

1. kubectl get pods等のrequestを行う
1. `~/.kube/config`に指定されたcommandが実行され、sts get caller-identity requestが作成され、tokenとしてencodeされrequestに付与される
1. Kubernetes Api serverはAWS IAM Authenticatorにそのtokenを渡す(たぶんWebhook)
1. IAM Authenticatorはsts get-caller-identityを実行し、Api serverにIAM Principalの情報を返す
1. ConfigMap `aws-auth`にてIAM Principalとrolebinding subject(group)のマッピングが行われる
1. Kubernetes上のrolebindingによって認可が実施される

### OIDC ID Provider

EKS Clusterを建てると裏側でOIDC ID Providerが設定される

## kube-apiserver Unauthorized

* eks用のconfig-mapにIAM Userを登録する必要がある
https://aws.amazon.com/jp/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/

## Troubleshooting

### kubectlが通らない

```
error: You must be logged in to the server (the server has asked for the client to provide credentials)  
```
## aws-auth

* `kube-system` namespaceに`aws-auth`というConfigMapが作成される。  
* aws-authがIAM Principalとkubernetesの権限の対応を管理する
* Clusterを作成したIAM Entityは自動で`service:masters` groupに追加される

### 設定例

```yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::11111111111:role/foo
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::123456789123:role/AWSReservedSSO_AdministratorAccess_0123456789abcdefg
      username: foo
      groups:
        - system:masters

```

* SSOのRoleを設定する場合
  * `rolearnから「/aws-reserved/sso.amazonaws.com/`を除外する
  * session名に表示される最後のpathはいれない


### 参考

* [設定例](https://repost.aws/knowledge-center/eks-configure-sso-user)
* [EKS Best Practice](https://aws.github.io/aws-eks-best-practices/security/docs/iam/#create-the-cluster-with-a-dedicated-iam-role)
* https://qiita.com/Ichi0124/items/d1e2424b0ea01967b05d
