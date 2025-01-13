# AWS Chat Bot

## 設定

1. AWS Chat Bot console > Configure Client
  * OAuthの認可画面にredirectられる

## IAM

* Organization policyにchatbot関連のものがある

* IAM Role
  * Channel role
    * channel memberが共通して利用できるrole
  * Guardrail policy
    * このpolicyで許可されていないと、channel or user roleで権限が付与されていても実行できない
