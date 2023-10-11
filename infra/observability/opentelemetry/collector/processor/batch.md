# batch processor

```yaml
processors:
  memory_limit: {}
  foo: {}
  batch:
    send_batch_size: 1000
    timeout: 1s
    send_batch_max_size: 2000

```

sampling等、dataをdropするprocessorの後に書く。

* `send_batch_size`: span, metric datapoints, log recordsの数。この数を超えるとbatchがtriggerされる。triggerされるだけであって、上限は指定されない。
* `timeout`: 現在のsizeに関わらずbatchがtriggerされる間隔。0だと即triggerされる。
* `send_batch_max_size`: 次のcomponentに渡すlimit。これを超えると分割される。send_batch_sizeと同じか大きい必要がある。
　　
