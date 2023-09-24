# systemd

Linuxにおけるinit実装の一つ

## 設定file

* `/usr/lib/systemd/system` | `/usr/systemd/system`
  * system unit directory
  * distributionが管理しているのでいじらない
* `/etc/systemd/system`
  * localな変更はこちらに行う
* `/etc/systemd/system.conf`
  * systemd init processの設定file
  * `man systemd-system.conf`

`pkg-config`を使って現在の設定を問い合わせることができる

```shell
pkg-config systemd --variable=systemdsystemunitdir
/lib/systemd/system

pkg-config systemd --variable=systemdsystemconfdir
/etc/systemd/system
```

## man

* `man systemd-system.conf`: systemdの設定file
* `man systemd.unit`: unit file
* `man systemd.directives`: 各directiveのmanへの参照がある

## Unit

systemdの操作単位。processの起動やfile systemのmount等のtaskを抽象化したもの。  
格納場所は

* `/lib/systemd/system/`
* `/etc/systemd/system/`
  * こちらのほうが同名fileの優先度が高い。基本はここらしい。

### Unit Type

* service: serviceの設定sysVの代替
* target: startup
* socket
* mount/automount: mount pointに関する情報  
* slice: cgroupの設定
* timer: cronの代替


## 参考

* [Understanding Systemd Units and Unit Files](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files)