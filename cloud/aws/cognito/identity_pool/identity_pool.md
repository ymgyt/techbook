# Identity Pool

* 外部/内部の(login済) tokenを受取、STSからCredential(AccessKeyId, SecretAccessKey, SessionToken)を払い出す
  * 認証を前提にしているので認可処理といえる
  * Credential broker

* 必ずCognito UserPoolを利用しなければいけないわけではなく、外部のIdPを利用できる?


## AWS Credential取得までの流れ

### enhanced(simplified) authentication flow

1. IdPからID Token(認証結果情報)を取得

2. identity_idの取得

  ```nu
  let identity_pool_id = "xxx"

  let identity_id = (
    aws cognito-identity get-id
      --identity-pool-id $identity_pool_id
      --logins $"($cognito_user_pool_id)=($id_token)"
    | from json | get "...")
  ```

3. IAM Role credentialの取得

  ```nu
  aws cognito-identity get-credentials-for-identity --identity-id $identity_id

  # handle credentials...

  aws sts get-caller-identity
  # => Identity poolで設定されたrole
  ```


### basic(classic) authentication flow

ClientがAssumeRoleWithWebidentityを呼ぶ方法
* SPA → GetId → GetOpenIdToken → AssumeRoleWithWebIdentity → 一時クレデンシャル
  * SPA が直接 STS を呼ぶ。Role の条件（Condition）を細かく制御できる。

## 認証結果とIAM Roleの紐づけ


* ruleベースでassumeさせるroleを管理できる
  * claimsが見える

* Cognito UserPool側でグループを作成して、そのグループにIAM Roleを設定
  * ID Pool側の設定で、tokenからroleを解決するを設定するとグループに設定したroleに解決される


## IdentityPoolが受け入れる認証結果

認証アーティファクトとも

* Cognito UserPool ID Token
* OIDC ID Token
* SAML 2.0 SAML Assertion
* SocialProvider Access token
