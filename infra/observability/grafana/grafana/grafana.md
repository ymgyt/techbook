# grafana

## Usage

```sh
# server 
grafana server \
  --config path/to/garafana.ini
```

## User Management

* 自分でdeployし、設定file変更していなければ、`admin/admin`のadmin userがいる

* builtin role
  * admin
    * 全てできる
  * editor
    * dashboardの変更ができる
    * data sourceの変更はできない
  * viewer
    * dashboardがみえる

### Team

userのgroupとしてteamがある

## Docker image

* [grafana](https://hub.docker.com/r/grafana/grafana)
* [grafana-oss](https://hub.docker.com/r/grafana/grafana-oss)
* [grafana-enterprise](https://hub.docker.com/r/grafana/grafana-enterprise)

* 初期ユーザは `admin/admin`

## API

### Health Check

* `/api/health`
  * 認証はない

## Local development

```yaml
name: foo

services:
  grafana:
    image: grafana/grafana-oss:11.5.1
    container_name: grafana
    restart: unless-stopped
    volumes:
      - type: volume
        source: grafana
        target: /var/lib/grafana
      - type: bind
        source: ./grafana/grafana.ini
        target: /etc/grafana/grafana.ini
        read_only: true
      - type: bind
        source: ./grafana/provisioning
        target: /etc/grafana/provisioning
        read_only: true
    environment:
      # GF_PLUGINS_PREINSTALL 環境変数では <plugin-id> <version> のように version を指定できなかったので、GF_INSTALL_PLUGINS を利用する
      GF_INSTALL_PLUGINS: "grafana-clock-panel 2.1.8, some-plugin 1.2.3"
      GF_PATHS_DATA: /var/lib/grafana
      GF_PATHS_CONFIG: /etc/grafana/grafana.ini
      GF_PATHS_PROVISIONING: /etc/grafana/provisioning
      GF_LOG_LEVEL: debug
      GF_LOG_MODE: console
      GF_AUTH_GOOGLE_CLIENT_ID: ${GF_AUTH_GOOGLE_CLIENT_ID}
      GF_AUTH_GOOGLE_CLIENT_SECRET: ${GF_AUTH_GOOGLE_CLIENT_SECRET}
    ports: ["3000:3000"]

volumes:
  grafana:
```


## Reference

* [Hardware recommendations](https://lwn.net/SubscriberLink/1007907/a9db87fc233bceae/)
