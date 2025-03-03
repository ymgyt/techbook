# Grafana Config

* `$WORKING_DIR/conf/defaults.ini`がdefault
* `$WORKING_DIR/conf/custom.ini`がoverride用?
  * `--config`で指定できる
* linux distroでは`/etc/grafa/grafana.ini`が`--config`で指定されているらしい

* `GF_<SECTION>_<KEYNAME>` 環境変数で設定fileを上書きできる
  * uppercaseにして、`.`と`-`を`_`に変換する
  * `auth.google.key`は `GF_AUTH_GOOGLE_KEY=bar`

```ini
[auth.google]
key = "hoge"
```

* Variable expansion
  * `$__env{VAR}`
    * 環境変数を展開する
    * `$__env{DIR}/bar`
  * `$__file{PATH}`
    * file path先の内容を展開する
    * `$__file{/run/secrets/key}`
    * secret(/run/secrets/key)で利用できる


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

