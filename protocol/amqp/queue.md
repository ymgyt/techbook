# Queue

## Declare

* つかわれる前に`declare`される必要がある
* 存在しない場合は作成される
* Queueが存在し、declarationのattributeが一致していればなにも起きない
* attributesが一致しなかった場合は406(PRECONDITION_FAILED)が返される
* serverのrestartに耐えるには,`durable=true`を指定する


## Publish

* Queueのdurabilityとは別にmessage自体にもdurabilityを設定することができる。
  * `properties.delivery_mode`に指定する。persistentの具体的な値がわからない。libにも見つからない。


## Dispatch

* defaultだと順番にconsumerにdispatchするだけ?
* `channel.basic_qos(prefetch_count=1)`を指定するとconsumerがackするまで新しいmessageをdeliveryしなくなる


