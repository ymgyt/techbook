# EKS

* versionについては[cluster upgrade](./cluster_upgrade.md)を参照

## Architecture

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

Clusterを作成したIAM Userは自動で`service:masters` groupに追加される

### Authentication flow

1. kubectl get pods等のrequestを行う
1. `~/.kube/config`に指定されたcommandが実行され、sts get caller-identity requestが作成され、tokenとしてencodeされrequestに付与される
1. Kubernetes Api serverはAWS IAM Authenticatorにそのtokenを渡す(たぶんWebhook)
1. IAM Authenticatorはsts get-caller-identityを実行し、Api serverにIAM Principalの情報を返す
1. ConfigMap `aws-auth`にてIAM Principalとrolebinding subject(group)のマッピングが行われる
1. Kubernetes上のrolebindingによって認可が実施される

## kube-apiserver Unauthorized

* eks用のconfig-mapにIAM Userを登録する必要がある
https://aws.amazon.com/jp/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/
