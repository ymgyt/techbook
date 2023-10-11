# systemctl

## Unit一覧の表示 `list-units`

```shell
systemctl list-units [--full] [--all]

systemctl list-units --type service --state dead
```

* `--full`: unitの正式名称を表示
* `--all`: inactiveなunitも含める
* `--type`: unit typeの指定(serviceとか)
* `--state`: stateの指定
  * `systemctl --state=help`で指定できるstateをみれる

memoryではなくfileベースでみるには

```sh
systemctl list-unit-files
```


## Unitのstatusを確認する

```shell
systemctl status sshd.service [--full]

# 設定fileの表示
systemctl cat opentelemetry-collector
```

* `-l` | `--full`: outputを省略しない

## Unitのstart,stop,reload

```shell
# unitをstart
systemctl start kubelet

# unitをstop
systemctl stop kubelet

# reload
systemctl reload kubelet

# 全てのunitのreload
systemctl daemon-reload

# 起動時の自動startを有効化
systemctl enable kubelet
```

* enableすると`/etc/systemd/system/multi-user.target.wants/kubelet.service` symlinkが作成される

## Show

systemd自身やunitについての情報を表示する

```shell
# kubeletのpropertyを表示
systemctl show kubelet

# systemdの設定fileの検索pathを表示
systemctl -p UnitPath show

# serviceの設定を確認する
systemctl cat telemetryd
```

## Unitの依存を確認

```shell
systemctl list-dependencies multi-user.target

# graphvizで可視化
 systemd-analyze dot multi-user.target | dot -Tsvg out> /tmp/target.svg
```

## shutdown

```shell
systemctl poweroff
```

## 再起動

```shell
systemctl reboot
```


