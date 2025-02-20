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

## Configuration

* `$WORKING_DIR/conf/defaults.ini`がdefault
* `$WORKING_DIR/conf/custom.ini`がoverride用?
  * `--config`で指定できる
* linux distroでは`/etc/grafa/grafana.ini`が`--config`で指定されているらしい

* [Doc](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/)


```init
[analytics]
enabled = true
# 最新のgrafanaをgithubに確認する
check_for_updates = true

[log]
# console | file | syslog
mode = "console"
# debug | info | warn | error | critical
level = "info"

# 各種dataのfile pathの指定
[paths]
# 実data
data = "/var/lib/grafana/"
# log
# command lineでcfg:default.paths.logsで上書きできるらしい
logs = "/var/log/grafana"
# plugins
plugins = "/var/lib/grafana/plugins"
provisioning = "/etc/grafana/provisioning"
```

### database

* [Doc](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#database)

### Google OAuth authentication

* [Doc](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/google/)

## Docker image

* [grafana](https://hub.docker.com/r/grafana/grafana)
* [grafana-oss](https://hub.docker.com/r/grafana/grafana-oss)
* [grafana-enterprise](https://hub.docker.com/r/grafana/grafana-enterprise)

* 初期ユーザは `admin/admin`


## Reference

* [Hardware recommendations](https://lwn.net/SubscriberLink/1007907/a9db87fc233bceae/)
