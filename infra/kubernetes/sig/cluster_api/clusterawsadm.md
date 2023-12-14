# clusterawsadm

Cluster Api Provider AWSが動作するための準備を行うtool

## Usage

```sh
# 設定に基づいて作成されるcloudformation templateを表示する
# 表示されたtemplateがcloudformation stackにapplyされる
clusterawsadm bootstrap ima print-cloudformation-stack --config bootstrap.yaml

# 設定に基づいてIAM関連のcloudformation stackを作成する
# 既にstackが存在する場合は更新処理が走る
clusterawsadm bootstrap ima create-cloudformation-stack --config bootstrap.yaml

# 現在のshell(環境変数)に設定されているaws credentialを`~/aws/config`のような形式でencodeする
clusterawsadm bootstrap credentials encode-as-profile
````

## bootstrap

* `clusterawsadm bootstrap iam print-config`で設定fileのyamlを出力できる
* [型定義](https://github.com/kubernetes-sigs/cluster-api-provider-aws/blob/cfc34d2e46349115895e423b3826639fed6b7906/cmd/clusterawsadm/api/bootstrap/v1beta1/types.go#L174)

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


#### source memo

1. configのtemplate yamlを読む。flagで渡さなければ初期化
1. regionの取得。flagがtemplate(yaml)に優先する
1. aws credentialはgo sdkのsession.NewSessionWithOptionsを利用
1. cloudformation [stack reconcile処理](https://github.com/kubernetes-sigs/cluster-api-provider-aws/blob/2a790d41db929d9ffaac8d7db7d64462ac27989e/cmd/clusterawsadm/cloudformation/service/service.go#L52)
  * createしてAlreadyExistsExceptionだったらupdateする
  * 適用するtemplateは`bootstrap.Template.RenderCloudFormation()`で生成される
    * `clusterawsadm bootstrap ima print-cloudformation-template`で表示されるものと同じ

