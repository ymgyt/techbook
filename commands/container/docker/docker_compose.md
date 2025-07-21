# docker-compose

* `docker compose`で実行できる

## 環境変数

意外なことにdocker-composeで環境変数のsubstitutionが使える。
https://docs.docker.com/compose/environment-variables/

## `services`

### Network

#### Hostとnetworkを共有する

```yaml
version: '3.8'
services:
  mongo1:
    image: mongo
    command: ["--bind_ip_all", "--port", "8302"]
    network_mode: host
```

* containerがhostのport8302でアクセルできるようになる
* `ports`の指定は無効になる

### `depends_on`

```yaml
services:
  service_a:
    healthcheck:
      test: ["CMD-SHELL", "curl -sSL http://localhost:8888"]
  service_b:
    depends_on:
      service_a:
        # https://github.com/compose-spec/compose-spec/blob/master/spec.md#long-syntax-1
        condition: service_healthy
```

* `depends_on.<service>.condition`で依存serviceの状態を指定できる
  * https://github.com/compose-spec/compose-spec/blob/master/spec.md#long-syntax-1
  * `service_started`
  * `service_healthy`
  * `service_completed_successfully`


### `healthcheck`

```yaml
services:
  service_a:
    healthcheck:
      test: ["CMD-SHELL", "curl -sSL http://localhost || exit 1"]
      interval: 1m30s   # default 30s
      timeout: 10s      # default 30s
      retries: 3        # default 3
      start_period: 40s # default 0s
```

* `test`の第一引数は`CMD`か`CMD-SHELL`を指定する。shellが使いたい場合は、`CMD-SHELL`
* exit statusは0か1を期待されているので、shellで`cmd || exit 1`のようにしている
  * 0: success - the container is healthy and ready for use
  * 1: unhealthy - the container is not working correctly
  * 2: reserved - do not use this exit code
* `start_period`期間中のtest commandの失敗はretry回数を減らさない。が、成功したらtestは通る。


### `volumes`

```yaml
services:
  backend:
    image: example/backend
    volumes:
      - type: volume
        source: db-data
        target: /data
        volume:
          nocopy: true
          subpath: sub
      - type: bind
        source: /var/run/postgres/postgres.sock
        target: /var/run/postgres/postgres.sock

volumes:
  db-data:
```

* `type`
  * `bind`
    * `source`と`target`を指定する
  * `volume`

## Examples

### minio

```yaml
version: '3.8'
services:
  # console credentials
  # minioadmin:minioadmin
  minio:
    image: minio/minio:RELEASE.2022-03-24T00-43-44Z
    command: ["server", "/data", "--console-address", ":9001"]
    ports:
      - "9000:9000"
      - "9001:9001"
```
