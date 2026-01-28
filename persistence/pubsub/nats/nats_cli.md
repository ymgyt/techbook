# NATs cli

`nats` コマンド

```sh
# --server $NATS_SERVER を毎回書かなくてよくなる
export NATS_SERVER="my-nats:4222"

# 疎通確認
nats server check connection

# Stream一覧
nats stream ls

# KeyValue 一覧
nats kv ls

# Stream詳細
nats stream info foo_coordinator_events

# coordinator events consumer一覧
nats consumer ls foo_coordinator_events

# consumer詳細
nats consumer report foo_coordinator_events
```
