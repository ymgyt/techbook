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
