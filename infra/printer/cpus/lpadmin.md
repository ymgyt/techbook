# lpadmin

```sh
sudo lpadmin -p apeos-c3571 -E -v "ipp://printer.local/ipp/print" -m everywhere
```

* `-p`: printer queueの作成
* `-E`: queue 有効化
* `-v`: 配送先
  * `ipp`
  * printer.local: host名
  * `/ipp/print` endpoint
* `-m`: drivermodel
  * `everywhere`
