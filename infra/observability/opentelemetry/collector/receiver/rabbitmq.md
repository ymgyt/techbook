# rabbitmqreceiver

## Resource attributes

* `rabbitmq.queue.name`
* `rabbitmq.node.name`
* `rabbitmq.vhost.name`

## Metrics


### Consumer 

* `rabbitmq.consumer.count`: queueをconsumeしているworkerの数
* `rabbitmq.message.delivered`: consumerに届けられたmessage数
* `rabbitmq.message.acknowledged`: consumerがackしたmessage数 

### Qeueu

* `rabbitmq.message.published`: queueにenqueueされたmessage数
* `rabbitmq.message.current`: 現在のqueueにあるmessage数
* `rabbitmq.message.dropped`: routingされずにdropされた数

## 参考

* [Metrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/rabbitmqreceiver/metadata.yaml)
