# AMQP 0-9-1

Advanced Message Queuing Protocolはclient applicationとbrokerとの通信に関するprotocol

## Memo

* Publisherがmessageを送る対象はExchange
* Exchangeにはbindingsが紐づいておりこれがmessageをcopyしたりしてQueueにroutingする
* Consumerがmessageをreceiveするとbrokerにacknowledgmentsを送り、broker側でmessageが削除される


