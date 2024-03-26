# tokio_metrics

## TaskMonitor

task遅いは以下に分類できる

* `Future::poll()`に時間がかかっている(consume too much CPU)
* そもそもpollされるまでに時間がかかっている(queueで待機している)
* external events(I/O)を長くまっている

これらを特定するためにどのmetricsを使うべきか

### Pollが遅い

* `mean_poll_duration`: pollの平均duration。これが増加している場合、そもそもpollが遅くなっている
* `slow_poll_ratio`: pollのうち、"slow"と分類される割合が増えている
* `mean_slow_poll_duration`: "slow" pollの平均。

defaultの"slow"は[50μs](https://docs.rs/tokio-metrics/latest/tokio_metrics/struct.TaskMonitor.html#associatedconstant.DEFAULT_SLOW_POLL_THRESHOLD)

#### なぜPollが遅くなるのか

* block apiを呼んでいないか
* `println!`等のsynchronousが関連していないか
* CPU boundな処理を行っていないか
