# terraform plan

## refresh-only

* `terraform plan -refresh-only`
* 実resourceの状態とstate(file) の差分を表示する
  * stateの更新はあくまで、`terraform apply -refresh-only` が必要
  * `-refresh-only` をapplyしても、dsl stateとのdriftは別の話
* 設定を宣言しているtf file(dsl state)との差分は表示されない


## detailed-exitcode

* exit codeのplanの差分を判定できる
* `-detailed-exitcode`
  * 0: 成功
  * 1: 実行エラー
  * 2: plan diff あり
