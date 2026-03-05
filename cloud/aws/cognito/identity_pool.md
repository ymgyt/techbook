# Identity Pool

* 外部/内部の(login済) tokenを受取、STSからCredential(AccessKeyId, SecretAccessKey, SessionToken)を払い出す
  * 認証を前提にしているので認可処理といえる

* 必ずCognito UserPoolを利用しなければいけないわけではなく、外部のIdPを利用できる?


## AWS Credential取得までの流れ

1. identity_idの取得

  ```nu
  let identity_pool_id = "xxx"

  let identity_id = (
    aws cognito-identity get-id
      --identity-pool-id $identity_pool_id
      --logins $"($cognito_user_pool_id)=($id_token)"
    | from json | get "...")
  ```

2. IAM Role credentialの取得

  ```nu
  aws cognito-identity get-credentials-for-identity --identity-id $identity_id

  # handle credentials...

  aws sts get-caller-identity
  # => Identity poolで設定されたrole
  ```


## 認証結果とIAM Roleの紐づけ


* ruleベースでassumeさせるroleを管理できる
  * claimsが見える
