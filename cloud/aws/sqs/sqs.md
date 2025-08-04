# SQS

## StandardとFIFO Queue

* FIFO
  * 送信された順番に受信されることが保証
  * Exactory-one 配信
  * スループットに制限あり

* Standard
  * 順序はベストエフォート
  * At-Least-Once
    * 重複時の制御はappの責務


## FIFO

### Duplication

* Content-Based-Deduplication
  * 有効
    * MessageBodyのHashが利用される
    * 明示的にMessageDeduplicationIdを指定するとリスペクト
  * 無効
    * MessageDeduplicationIdの指定が必須

* 重複とみなすスコープは５分間
  
