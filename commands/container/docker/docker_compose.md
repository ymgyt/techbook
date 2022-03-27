# docker-compose

* `docker compose`で実行できる

## Network

### Hostとnetworkを共有する

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

## 環境変数

意外なことにdocker-composeで環境変数のsubstitutionが使える。
https://docs.docker.com/compose/environment-variables/

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
