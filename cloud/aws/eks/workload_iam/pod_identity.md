# EKS Pod Identity

IRSAはEKS(EKS Anyware, Redhat OpenShift, EC2 Self host)に限らないが、Pod IdentityはEKS専用


## 比較

| / | IRSA | Pod Identity |
| -- | --- | --- |
| Scope | EKS,Anyware,OpenShift,SelfHost | EKS |
| IAM Role Session Tags support | False | True | 


## Walkthroug

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
