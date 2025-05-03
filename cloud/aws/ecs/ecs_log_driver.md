# ECS Log Driver

* Applicationがlogをlog serverに送れない場合にtrafficを処理し続けるか
  * audit logが優先される場合は、appをとめる
  * logを失うおそれがあってもserveし続ける
* Log driverでどちらを選ぶか選択できる

Task definition `logConfiguration.options.mode` で "blocking" か "non-blocking"を選択できる
```json
"containerDefinitions": [
  {
    "name": "foo",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "mode": "non-blocking"
        "max-buffer-size": "1m"
      },
    }
  }
]
```

* blocking mode
  * CloudWatchへのPUTができない場合、application(container)のstdout へのwriteがblockする
* max-buffer-size で指定されたbufferにlogが書き込まれる
  * defaultは `1m`
  * 推奨は `25m`


## blocking と non-blocking の違い

* blocking
  * なんらかの理由でCloudWatchにログを送れない時(PutLogEvents apiが失敗)、コンテナ(アプリケーション)の stdout/stderr への write がブロックする

* non-blocking
  * ログは buffer に書き込まれ、CloudWatchにログが送れない場合でもブロックしない
  * buffer が一杯になるとログはロストする

### 判断基準

## 参照

* [Preventing log loss with non-blocking mode in the AWSLogs container log driver](https://aws.amazon.com/blogs/containers/preventing-log-loss-with-non-blocking-mode-in-the-awslogs-container-log-driver/)
* [Choosing container logging options to avoid backpressure](https://aws.amazon.com/blogs/containers/choosing-container-logging-options-to-avoid-backpressure/)


* [ non-blocking時の実装例](v19)(https://github.com/moby/moby/blob/bd33bbf0497b2327516dc799a5e541b720822a4c/daemon/logger/awslogs/cloudwatchlogs.go#L407) 
  * https://github.com/moby/moby/blob/bd33bbf0497b2327516dc799a5e541b720822a4c/daemon/logger/awslogs/cloudwatchlogs.go#L218

* [現在のmaster実装](https://github.com/moby/moby/blob/b0e8932009f73a3c624c4df3cde790455b37c951/daemon/logger/ring.go#L174) 
  * buffer が一杯のときはメッセージを捨てていそう
