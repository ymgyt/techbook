# Exchange

* AMQPのentity.
* Exchange take a message and route it into zero or more queues.
* routingのruleはbindings
* Exchange Types
    * Direct exchange
    * Fanout exchange
    * Topic exchange
    * Headers exchange
* Exchangeはattributeと共にdeclaredされる
* Exchangeはdurable or transient
    * Durableはbrokerのrestartを超えてsurviveできる

## Default Exchange

* empty stringでbrokerにあらかじめdeclaredされている、direct exchange
* routing key(binding key)をもちここにqueueの名前をいれるとそのqueueにmessageを送れる
* Exchangeを透過的にし、あたかもちょくせつqueueにmessageを送れるように機能している。
