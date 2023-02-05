# systemctl

## Unit

systemdにおける管理単位。

## Unitの確認

### Unitの一覧の取得

```shell
systemctl list-units
```

systemdがparseしていないがfile pathにおいてあるunitも含めて表示する場合

```shell
systemctl list-unit-files
```

### Unitの詳細

```shell
systemctl cat xxx.service
```


## Serviceの状態確認

```shell
systemctl status xxx.service
```

## Serviceの起動と停止

```shell
# Start
systemctl start xxx.service

# Stop
systemctl stop xxx.service

# Restart
systemctl restart xxx.service

# Reload
systemctl reload xxx.service

# Reloadできるかわからない場合は
systemctl reload-or-restart xxx.service

# Kernel起動時に自動でserviceを起動する。startはしないので注意
systemctl enable xxx.service
```
