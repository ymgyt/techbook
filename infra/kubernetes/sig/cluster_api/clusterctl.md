# clusterctl

## init

```sh
clusterctl init --infrastructure aws
```

* kubectlが指してるclusterにcluste api関連のcomponentをinstallしてmanagement clusterにする
* optionalな機能の追加は環境変数経由で行う


## EKS

### Memo

* MachinePool
  * `AWSMachinePool` crd, awsのAutoScaling Groupに対応する

* `CAPA_EKS_IAM`
  * EKSがclusterごとに専用のIAM Roleを使うかどうか
  * clusterawsadm的にはiamRoleCreationに該当する

* `EXP_EKS_FARGATE`


### init memo

```sh
export AWS_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

clusterawsadm bootstrap iam create-cloudformation-stack
```

CloudFormationに`cluster-api-provider-aws-sigs-k8s-io` stackが作成される。  
IAM関連のresourceが作成される

```sh
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)

clusterctl init --infrastructure aws:v2.2.4
```

versionはproviderのgithub 最新を選んだ