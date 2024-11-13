# IAM PassRole

* あるAWS Service XにRole Aを設定する際にPrincipal(AWS User)に必要な権限(policy)
  * EC2にあるRoleを付与するというケース

* PassRoleというAPI Callがあるわけではなさそう

## なぜ `iam::PassRole`が必要か

EC2 Admin権限だけがあるユーザが任意のRoleをEC2に付与できるとすると、AdministratorAccessをEC2に付与してssh
すれば結果的にAdministratorAccessを取得できてしまう  
なので、ユーザが付与できるRoleの範囲を制限できるような権限が必要になる

## 渡すRoleの制限

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "IAMPassRoleForEC2",
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "arn:aws:iam::12345:role/EC2Role",
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": [
            "ec2.amazonaws.com"
          ]
        }
      }
    }
  ]
}
```

* Resource: に渡せるroleを指定する
* `Condition.StringEquals."iam:PassedToService"`で渡す先のサービスを指定できる
  * https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_iam-condition-keys.html


制限しない例
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [ "iam:PassRole" ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

## Reference

* [公式 Grant a user permissions to pass a role to an AWS service](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_passrole.html)
* [IAMのPassRoleとセキュリティの話](https://qiita.com/koheiawa/items/044a1ccf08482287da16)
* [iam::PassRoleってなんだ](https://www.karakaram.com/granting-iam-user-permission-to-pass-iam-role-to-aws-services/#google_vignette)
* [AWSサービスに渡すIAMロールを制限する](https://dev.classmethod.jp/articles/restrict-pass-ima-role-with-passrole/)
* [IAM ロールを特定の AWS のサービスに渡す](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_examples_iam-passrole-service.html)


```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "arn:aws:iam::058264255763:role/GhaCodeBuildHostedRunner",
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": [
            "codebuild.amazonaws.com"
          ]
        }
      }
    }
  ]
}
```
