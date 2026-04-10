# Lambda Runtime

Lambdaがどうやって実行されているかについて。

## 登場人物

* Lambda Service: AWSが管理するcontrol plane
  * runtime apiでやりとりする
* Runtime: 実行環境
　* serviceとfunctionのinteractionを担当する
* Function
  * Handlerの実装

## 実行までの流れ

1. Serviceがexecution environmentを作る

2. Serviceが`bootstrap` binaryを起動する
　* `lambda_runtime::run()`までを起動する
  * `/next` API呼び出しまでを init phaseと説明される
    * custom runtimeの場合、runtime initと function initは区別されないと思われる

3. runtimeが`/runtime/invocation/next` runtime apiを実行
  * lambdaの呼び出しを表現するeventを取得し、handlerを呼び出す
  * 成功時は `/runtime/invocation/{id}/response`にPOST

4. `/next` 呼び出し時に実行環境がsuspendされることがある

5. shutdown.
  * runtimeには通知がこない
  　* Dropの終了処理に期待できない
  * extensionには来る

## Runtime

Service(runtime api)とhanlderの仲介役.
Rustの場合はcustom runtimeとしてユーザのbinary側でここの制御まで行う。
