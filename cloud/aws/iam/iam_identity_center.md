# IAM Identity Center

元、AWS SSO(Single Sine On)

## SSO Instance

AWS Organizationのmanagement accountに対して1:1で紐づく概念。  

## ID Store

SSO Instanceに紐づく

## アクセス権限セット

Policyを複数割り当てる存在。

## CLI

```sh
aws configure sso
SSO session name (Recommended): ymgyt-sso
SSO start URL [None]: https://foo.awsapps.com/start#/
SSO region [None]: ap-northeast-1
SSO registration scopes [sso:account:access]:
```

これを実施すると`~/.aws/config`に指定したprofileが追加される

以下のようにprofileとssoの情報を記載する

```text
[profile my-profile]
sso_session = foo-sso
sso_account_id = <TARGET_AWS_ACCOUNT_ID>
sso_role_name = <ROLE_TO_ASSUME>
region = ap-northeast-1

[sso-session foo-sso]
sso_start_url = https://foo.awsapps.com/start#/
sso_region = ap-northeast-1
sso_registration_scopes = sso:account:access
```


利用前にloginする

```sh
aws sso login --profile my-profile

# session単位で更新する
aws sso login --sso-session foo-sso
```

