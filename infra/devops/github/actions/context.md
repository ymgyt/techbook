# Contexts

* workflowの中で参照できる変数(環境変数やsecret)
  * github
  * env: 環境変数
  * secrets: Repositoryに設定してあるsecret

* `${{ <context> }}`で参照する
  * `${{ env.REPOSITORY }}`
  * `${{ secret.API_KEY }}`

