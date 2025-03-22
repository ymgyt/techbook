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

* `systemctl show --property=UnitPath`で現在の設定を確認できる。

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
* `man systemd.kill`: Processの終了関連
* `man systemd.exec`
* `man systemd.service`
* `man systemd.special`
* `man bootup`: 起動関連

## Target

他のsystemdのunitをまとめるためのunit。  
`systemctl list-units -t target`で一覧をみれる。

* `multi-user.target`: the operation system is fully operational, without a graphical inteface.
* `graphical.target`: the operation system is fully operational, with a graphcial inteface.

## Boot process

systemdはboot時に`default.target`を起動する


## 参考

* [Understanding Systemd Units and Unit Files](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files)