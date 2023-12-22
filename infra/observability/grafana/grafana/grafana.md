# grafana

## Usage

```sh
# server 
grafana server \
  --config path/to/garafana.ini
```

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

