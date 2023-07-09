# mongo

* mongodのclient cli

## Install

```shell
# Mac
brew install mongodb-community@4.2
mongo --version
```

## Connect

**defaultではauthenticationが無効。**  
なので、`mongo --port 30001`のようにして接続できる。

```shell
mongo --port 27017 --username "myUserAdmin" --password "abc123" --authenticationDatabase "admin"
```

## Usage

### Remote execution

remoteのmongodに接続してコマンドを実行するには`--eval()`を利用する。
```shell
mongo --port 30001 --eval 'rs.status().ok' --quiet
```

## Docker

```yaml
version: '3.8'

services:
  mongo1:
    image: mongo:4.2
    container_name: mongo1
    command: ["--replSet", "rs0", "--bind_ip_all", "--port", "8301"]
    network_mode: host
    healthcheck:
      test: test $$(echo "rs.status().ok || rs.initiate({_id:'lawgue-replica-set',members:[{_id:0,host:\"localhost:8301\",priority:10},{_id:1,host:\"localhost:8302\",priority:5},{_id:2,host:\"localhost:8303\",priority:1}]}).ok" | mongo --port 8301 --quiet) -eq 1
      interval: 10s
      start_period: 30s

  mongo2:
    image: mongo:4.2
    container_name: mongo2
    command: ["--replSet", "rs0", "--bind_ip_all", "--port", "8302"]
    network_mode: host

  mongo3:
    image: mongo:4.2
    container_name: mongo3
    command: ["--replSet", "rs0", "--bind_ip_all", "--port", "8303"]
    network_mode: host
```

`docker compose up`後にprimaryのelection processが走るので完了を待機するには以下のようなscriptを利用する。  
`network_mode: host`を利用しているのは、server selectionで、mongoが認識しているhostがclientに返されるため、`mongo1:8301`のようなurlになるとclientから接続できないため。

```shell
echo -n "waiting mongodb replicaset startup.."
# CONTROL  [js] machdep.cpu.extfeatures unavailable のようなlogが出力されるので、tailを入れている
while test $(mongo --port 8301 --eval 'rs.status().ok' --quiet  | tail -n 1) -ne 1
do
  echo -n "."
  sleep 2
done
echo " ok"
```

## Commands

```shell
# switch current db
use app

# list collections
show collections
```
