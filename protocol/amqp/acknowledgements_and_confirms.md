# Consumer Acknowledgements and Publisher Confirms


## Memo

* consumerのacknowledgementsはdelivery tagによってmessageを識別している
  * delivery tagはchannel scoped
* 30minuteがdefaultのacknowledgment timeout
  * timeout以内にacknowledgementをconsumerが返さないと、再び処理対象になる
