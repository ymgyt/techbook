# Workload IAM

Pod, ServiceAccountとAWS IAMとの連携方法

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

### IRSAの設定

前提 EKS ClusterのOIDC ProviderとIAM OIDC Providerが連携されている。

  
## EKS Pod Identity

IRSAはEKS(EKS Anyware, Redhat OpenShift, EC2 Self host)に限らないが、Pod IdentityはEKS専用


### 比較

| / | IRSA | Pod Identity |
| -- | --- | --- |
| Scope | EKS,Anyware,OpenShift,SelfHost | EKS |
| IAM Role Session Tags support | False | True | 


### Walkthroug

1. IAM Roleのassume policyを以下のように作成

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "pods.eks.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRole",
        "sts:TagSession"
      ],
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "my-account-number"
        },
        "ArnEquals": {
          "aws:SourceArn": "arn-of-my-eks-cluster"
        }
      }
    }
  ]
}
```

* `Principal.Service: "pods.eks.amazonaws.com"`を指定する
* IAMのOIDCの設定をせずにIAM RoleをassumeできるService Accountを指定できる


2. IAM RoleとService Accountのassociationを作成する

* `CreatePodIdentityAssociation` APIを利用する


3. AssociationしてService AccountでPodを作成する

* [EKS Pod Identity webhook](https://github.com/aws/amazon-eks-pod-identity-webhook)が実行される
* AWS SDKが確認する場所にcredentialがsetされる
* CredentialはHTTP経由で取得され、EndpointはEKS Pod Identity Agetnがserveする
  * Pod Identity Agentはworker nodeで動いている
  * DaemonSet
  * Add-on管理
* AWS SDKはEKS Pod Identityの処理をしっている必要があるのでversionに注意
