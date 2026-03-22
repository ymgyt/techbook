# Lambda Trigger

* Cognitoの各hook pointにlambdaを差し込める機能
* Trigger type
  * Pre token generation


## Pre token generation

* id token, access tokenのclaimsをlambdaで制御できる
  * 認証結果をAPIが使いやすいauthorization情報に変換する変換器
