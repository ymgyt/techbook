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
```
