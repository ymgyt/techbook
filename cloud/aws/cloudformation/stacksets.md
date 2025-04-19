# StackSets

* Stack Instance
  * Admin AccountにあるStackSetがtarget accountがinstanciateされたもの

* Api
  * create-stack-set
    * これで、admin account にstack set instanceができる
  * create-stack-instances
    * target accountにstackができる

## Permission models

* service-managed permissions
  * AWS Organization 使うパターン
  * Stack自体にdeploy先アカウントのIAM Roleがある?


## Target Account

* StackSetをdeployするaccountがassume する用のRoleが必要
  * Principal がadmin account のsts:AssumeRoleをassume role policyに設定する
