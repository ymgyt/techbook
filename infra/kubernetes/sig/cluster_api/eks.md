# EKS Clusterの構築

## Memo

* MachinePool
  * `AWSMachinePool` crd, awsのAutoScaling Groupに対応する

* `CAPA_EKS_IAM`
  * EKSがclusterごとに専用のIAM Roleを使うかどうか
  * clusterawsadm的にはiamRoleCreationに該当する

* `EXP_EKS_FARGATE`
* AMIは`clusterawsadm ami list`


## init memo

IAM用の設定file `bootstrap-config.yaml`を作成

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    iamRoleCreation: false # Set to true if you plan to use the EKSEnableIAM feature flag to enable automatic creation of IAM roles
    managedMachinePool:
      disable: false # Set to false to enable creation of the default node role for managed machine pools
    fargate:
      disable: false # Set to false to enable creation of the default role for the fargate profiles
```

cluster providerで有効にするoptionと対応させる必要がある。

```sh
export AWS_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

clusterawsadm bootstrap iam create-cloudformation-stack  --config bootstrap-config.yaml
```

CloudFormationに`cluster-api-provider-aws-sigs-k8s-io` stackが作成される。  
IAM関連のresourceが作成される

```sh
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)

clusterctl init --infrastructure aws:v2.2.4
```

* versionはproviderのgithub 最新を選んだ
* 有効化するfeatureは環境変数で指定できる

### Feature gate

https://cluster-api-aws.sigs.k8s.io/topics/reference/reference

## generate cluster

```sh
clusterctl generate cluster clusterapi-workload-1 --flavor eks-managedmachinepool --kubernetes-version v1.27.0 --worker-machine-count=3 > clusterapi-workload-1.yaml

# apply
kubectl apply -f clusterapi-workload-1.yaml
```

## clusterawsadm

## bootstrap

`bootstrap-config.yaml`

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    iamRoleCreation: false # Set to true if you plan to use the EKSEnableIAM feature flag to enable automatic creation of IAM roles
    managedMachinePool:
      disable: false # Set to false to enable creation of the default node role for managed machine pools
    fargate:
      disable: false # Set to false to enable creation of the default role for the fargate profiles
```

### IAM CloudFormation Stackの更新

```sh
clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap-config.yaml
```

* `create-cloudformation-stack`で、既に存在する場合は更新処理になる