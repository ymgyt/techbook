# memory limiter

```yaml
processors:
  memory_limiter:
    check_interval: 1s
    limit_mib: 500
    spike_limit_mib: 100
    # limit_percentage: 0
    # spike_limit_percentage: 0
```

**processorsの最初に定義する**
(理由はerrorをreceiverに返してあわよくばback presureしたいから)

soft limitとhard limitがある。  
soft limit < hard limitである必要がある。  
soft limitを超えると、receiverにerrorを返す。  
実装的にはConsumeLogs,Traces,Metricsらしい。  
したがって、memory_limiterはprocessorの最初にあることが期待されている。

* `check_interval`:  メモリ使用量の測定間隔。推奨値は1秒。
* `limit_mib`: heapの割当最大量。hard limitを定義する。この値+50MiBが使われる。
* `spike_limit_mib`: limit_mibより小さい必要がある。soft limitはlimib_mib - spike_limit_mibで決まる。推奨値はlimit_mibの20%
* `limit_percentage`: よくわかっていない。limit_mibが設定してあればそれが優先される。
* `spike_limit_percentage`: limit_percentageとあわせて使う。
