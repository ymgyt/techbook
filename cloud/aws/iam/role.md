# IAM Role

* Roleには2つのPolicyを設定する
  * 誰が当該roleをassumeできるか
    * trust policyと言われたりする
  * そのRoleで何ができるか

## Trust Policy

### OpenID Connect Federation

* AWS外でIDを管理している場合、AWSの外のID(User等)にAWS Resourceへの権限を付与できる仕組み

* 外部IDはOIDC(OpenID Connect)かSAML2.0を利用できる

* OIDCで表現された外部のID(Entity)にRoleをassumeできることを表現できる

* GithubはOIDC ID Providerになれるので、あるGithub actionから利用できるRoleを表現できる

```json
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": {"Federated": "cognito-identity.amazonaws.com"},
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {"accounts.google.com:aud": "foobar123"}
        }
    }
}
```

* `Action`は`sts:AssumeRoleWithWebIdentity`
* `Principal`
  * `Federated`にprovider urlを指定する
* `Condition`はID Providerごとに異なる
  * 一般的にはaudか?

Roleをassumeする際はstsの`AssumeRoleWithIdentity` apiを利用する。  その際にOIDC ID Providerが発行したtoken(jwt)を付与する

### Cross Account

Cross Accountでのtrust policyの書き方

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::[ASSUMER_ACCOUNT_ID]:root"
  },
  "Action": "sts:AssumeRole",
  "Condition": {
    "StringLike": {
      "aws:PrincipalArn": "arn:aws:iam::[ASSUMER_ACCOUNT_ID]:role/[ROLE_NAME]"
    }
  }
}
```

* Principalでアカウントを指定して,　`aws:PrincipalArn` conditionを付与しておくとRoleの再作成が行われても壊れない
* PrincipalにRoleARNを指定すると内部的にPrincipal IDの解決が作成時に行われ、Role再作成で壊れるらしい
