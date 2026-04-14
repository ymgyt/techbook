# CPUS

## Memo

```sh
lpstat -h

lpstat -p foo -l

sudo lpadmin -p foo -E -v "ipp://printer.local/ipp/print" -m everywhere

# default 登録
lpoptions -d foo
```

* Components
  * `CPUS` 印刷管理daemon `services.printing`
  * `lp`   CLI client
  * `lpadmin` CPUS管理コマンド
  * `queue`: 印刷先設定object

