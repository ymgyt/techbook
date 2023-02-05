# systemd

Linuxにおけるinit実装の一つ

## 設定file

* `/usr/lib/systemd/system` | `/usr/systemd/system`
  * system unit directory
  * distributionが管理しているのでいじらない
* `/etc/systemd/system`
  * localな変更はこちらに行う

`pkg-config`を使って現在の設定を問い合わせることができる

```shell
pkg-config systemd --variable=systemdsystemunitdir
/lib/systemd/system

pkg-config systemd --variable=systemdsystemconfdir
/etc/systemd/system
```

## Unit

systemdの操作単位。processの起動やfile systemのmount等のtaskを抽象化したもの。

### Unit Type

* service
* target
* socket
* mount