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

## Range function

* `rate()`: 期間の最後の値から期間の最初の値を引いて、時間で割った値。出力値はValue/1sとなる
* `increase()`: rateの出力に時間幅を掛けた値。2/1秒がrateで[5m]で使ったら、5分間の出力値となる

## Etc

grafanaやpromqlで使える特殊な変数

* `$__interval` 二つのdata pointの間隔。scrapeする間隔の設定によるがqueryには埋め込みたくない場合に便利
  * 例えば、`increase(foo[$__interval])` とすると前回のdatapointからの差分をだせる
