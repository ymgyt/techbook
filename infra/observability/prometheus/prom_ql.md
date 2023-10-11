# PromQL

## Examples

```text
rate(prometheus_tsdb_head_samples_appended_total[1m])

# 全体(total)に対する率をだす
rate(my_metrics_count[1m])
/
rate(my_count_total[1m])

# label matcher
xxx{job="yyy"}

# 落ちているjobをみつける
up == 0

# 全てのtime seriesを返す
foo_total

# labelで絞る
foo_total{key=value}            # equal
foo_total{key!=value}           # not equal
foo_total{key=~"value.+"}       # regex match
foo_total{key!~"value.+"}       # regex not match

foo_total{key_1=value1, key_2=value_2} # and
foo_total{key=~"v_1|v_2"}              # orはregexで表現できる

# 複数のmetricsを取得
{__name__=~"(foo|bar)_total"}
```

## Aggregation


```
{ host, cpu, mode}があるとする

sum without (cpu, mode) (system_cpu_utilization)
は以下と同じ
sum by (host) (system_cpu_utilization) 
```

* withoutは指定のfieldを無視して残ったkeyが同じtime seriesをaggregateす
* byは指定のfieldが同じtime seriesをaggregateする
