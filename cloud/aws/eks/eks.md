# EKS

* versionについては[cluster upgrade](./cluster_upgrade.md)を参照
* GA、betaのfeatureはsupportされる
  * alphaはsupportされない

## Architecture

### IAM

EKS ClusterがAWS Resource(managed nodes)を操作するためにIAM Roleが必要。
これは事前に`AmazonEKSClusterPolicy`かそれに代替するpolicyを付与したIAM Roleを作っておく

EKS Node(Worker node)に必要なIMA Policyは以下  
[Amazon EKS node IAM role](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

### VPC

* VPCを指定する必要がある
* 最低2つのsubnetが必要
  * 異なるAZ

* [EKS VPC and subnet requirements](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)

### Control plane

* 最低2つのapi server
  * 3つのetcd
  * AZ間に分散

### Worker nodes

worker nodeの管理方法にも選択肢がある。
混在させることもできる(たぶん)

* AWS Fargate
* Karnenter
* Managed node group
* Self managed nodes

## Authentication


EKSにおける認証について。  
まずEKS Cluster作成時に`aws-auth`というConfigMapが`kube-system` namespaceに作成される。

* Clusterを作成したIAM Entityは自動で`service:masters` groupに追加される
  * このIAM Entityはどのconfigurationにも現れない
  * AWS以外の仕組みで誰が作ったのかを管理しておく必要がある

* [EKSの認証認可の仕組み](https://zenn.dev/take4s5i/articles/aws-eks-authentication)

### Authentication mode

Clusterには以下のいずれかのauthentication modeの設定がある。

* `aws-auth` ConfigMap (`CONFIG_MAP`)
  * 今までの方法
* ConfigMapとaccess entries(`API_AND_CONFIG_MAP`)
  * ConfigMapとaccess entriesは独立している
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

### Authentication flow

1. kubectl get pods等のrequestを行う
1. `~/.kube/config`に指定されたcommandが実行され、sts get caller-identity requestが作成され、tokenとしてencodeされrequestに付与される
1. Kubernetes Api serverはAWS IAM Authenticatorにそのtokenを渡す(たぶんWebhook)
1. IAM Authenticatorはsts get-caller-identityを実行し、Api serverにIAM Principalの情報を返す
1. ConfigMap `aws-auth`にてIAM Principalとrolebinding subject(group)のマッピングが行われる
1. Kubernetes上のrolebindingによって認可が実施される

### aws-auth

`kube-system` namespaceに`aws-auth`というConfigMapが作成される。  
aws-authがIAM Principalとkubernetesの権限の対応を管理する

* [設定例](https://repost.aws/knowledge-center/eks-configure-sso-user)
* [EKS Best Practice](https://aws.github.io/aws-eks-best-practices/security/docs/iam/#create-the-cluster-with-a-dedicated-iam-role)

### OIDC ID Provider

EKS Clusterを建てると裏側でOIDC ID Providerが設定される

## kube-apiserver Unauthorized

* eks用のconfig-mapにIAM Userを登録する必要がある
https://aws.amazon.com/jp/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/

## IRSA

IAM Role for Service Accounts  
Service accountとIAM Roleを紐づけることで、PodごとにAWS権限を制御できる仕組み。

概ね以下の流れ。

1. `kubectl apply -f deployment.yaml`でPodが作成される
2. apiserverのadmission controlが実行される
  2.1 Mutating Admission webhookが実行される
  2.2 [eks-pod-identity-webhook](https://github.com/aws/amazon-eks-pod-identity-webhook) が実行される
3. Podの`spec.serviceAccountName`で指定されたservice accountのannotation(`eks.amazonaws.com/role-arn: ARN`)に基づいてPodのcredentialが設定される
  3.1 環境変数 `AWS_ROLE_ARN`, `AWS_WEB_IDENTITY_TOKEN_FILE`が設定される
  3.2 EKSのIdpが発行したjwtが発行される
4. AWS SDKが`sts:AssumeRoleWithWebIdentity`を実行する
  4.1 上記の設定された環境変数を考慮する
5. Roleがassumeされ、そのcredentialを利用する
  

## Log

* Controll planeのlogは明示的に有効に設定する必要がある
  * 設定はcomponentごとに制御する

* Component
  * `api` kube-apiserver
  * `audit` kubernetesのaudit
  * `authenticator` EKS固有
    * STSの解決結果のlogのっていたりする
  * `controllerManager`
  * `scheduler`

* Cloudwatch log groupは`/aws/eks/<custer-name>/cluster`になる
  * logのretention daysはこの名前に設定する

## Troubleshooting

### kubectlが通らない

```
error: You must be logged in to the server (the server has asked for the client to provide credentials)  
```

Cloudwatch logs insightにて

logGroup `/aws/eks/<cluster-name>/cluster`

```
fields @logstream, @timestamp, @message
| sort @timestamp desc
| filter @logStream like /authenticator/
| limit 50
```

で認証の成功/失敗のlogがでるので確認する
