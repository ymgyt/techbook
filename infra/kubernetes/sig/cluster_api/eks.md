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

## Cleanup

1. workload clusterの削除
  * `kubectl delete cluster <workload_cluster>`
2. managment clusterの削除
  * `terraform destroy`
3. iam cloudformation 削除
  * `clusterawsadm bootstrap iam delete-cloudformation-stack`


## Multi tenancy

* workload clusterごとに異なるAWS Identityを利用できる機能

* `Cluster` -> `AWSManagedControlPlane` -> `AWSIdentityReference`
  * managed control planeをreconcilingする際に利用するaws identity

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSCluster
metadata:
  name: "test"
  namespace: "test"
spec:
  region: "eu-west-1"
  identityRef:
    kind: <IdentityType>
    name: <IdentityName>
```

* `AWSCluster.spec.identityRef`でcontrollerにreconcilingする際にどのidentityを使うかを指示する


1. management用の`clusterawsadm` 設定fileを用意する

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  region: ap-northeast-1
  allowAssumeRole: true
  clusterAPIControllers:
    disable: false
    extraStatements:
    - Action: ["sts:AssumeRole"]
      Effect: "Allow"
      Resource: ["arn:aws:iam::<workload>:role/controllers.cluster-api-provider-aws.sigs.k8s.io"]
    trustStatements:
    - Action: ["sts:AssumeRoleWithWebIdentity"]
      Effect: "Allow"
      Principal:
        Federated: ["arn:aws:iam::<management>:oidc-provider/oidc.eks.ap-northeast-1.amazonaws.com/id/<oidc-provider-id>"]
      Condition:
        "ForAnyValue:StringEquals":
          "oidc.eks.ap-northeast-1.amazonaws.com/id/<oidc-provider-id>:sub":
            - system:serviceaccount:capi-providers:capa-controller-manager
            - system:serviceaccount:capa-eks-control-plane-system:capa-eks-control-plane-controller-manager
  eks:
    defaultControlPlaneRole:
      disable: false
    disable: false
    fargate:
      disable: false
    iamRoleCreation: true
    kmsAliasPrefix: cluster-api-provider-aws-*
    managedMachinePool:
      disable: false
```

* `<oidc-provider-id>`はEKSのOpenID Connect provider URLから確認できる
* この設定によってIAM Role `controllers.cluster-api-provider-aws.sigs.k8s.io`にpolicyが追加される
  * これはcapaがassumeするrole

2. management accountにIAM用のCF Stackを作成する

`clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap-manager-account.yaml`

* 事前に`AWS_`系の環境変数にmanagement account用の権限を設定しておく

3. management clusterにcluterapi operatorsをinstallする

```sh
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
export EKS=true
export EXP_MACHINE_POOL=true
export AWS_CONTROLLER_IAM_ROLE=arn:aws:iam::${AWS_MANAGER_ACCOUNT_ID}:role/controllers.cluster-api-provider-aws.sigs.k8s.io
clusterctl init --kubeconfig manager.kubeconfig --infrastructure aws --target-namespace capi-providers
```

* 設定するfeatureの環境変数は必要に応じて設定する


4. workload clusterを操作できるIAM Roleを作成する

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSClusterRoleIdentity
metadata:
  name: workload-role
spec:
  allowedNamespaces: {} 
  roleARN: arn:aws:iam::<workload>:role/controllers.cluster-api-provider-aws.sigs.k8s.io
  sourceIdentityRef:
    kind: AWSClusterControllerIdentity
    name: default
```

`kubectl apply -f workload-role-identity.yaml`

* `roleARN`に対応するroleはclusterawsadmで作成する

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  region: ap-northeast-1
  eks:
    iamRoleCreation: false
    managedMachinePool:
      disable: false
    fargate:
      disable: false
  clusterAPIControllers:
    disabled: false
    extraStatements:
      # kubectl delete -f lawgue-dev-1-28.yaml 時にこの権限がなくてエラーとなっていたので付与した
    - Action: ["ec2:DescribeVpcEndpoints"]
      Effect: "Allow"
      Resource: ["*"]
    trustStatements:
    - Action:
      - "sts:AssumeRole"
      Effect: "Allow"
      Principal:
        AWS:
        - "arn:aws:iam::<management>:role/controllers.cluster-api-provider-aws.sigs.k8s.io"
```

次はworkload用aws accountの環境変数をセットして

`clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap-managed-account.yaml`


5. workload cluster用のkubeconfigを作成

`aws eks update-kubeconfig`でkubeconfigを生成する
