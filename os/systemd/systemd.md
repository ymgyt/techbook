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
* `man systemd.unit`: Unit sectionの説明
* `man systemd.kill`: Processの終了関連
* `man systemd.exec`

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

## Directives

### Unit

```text
[Unit]
Description=Foo Service
After=network.target remote-fs.target nss-lookup.target
Documentation=https://docs.ymgyt.io
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run
```

* `ConditionPathExists`: pathの存在で制御できる

## Target

他のsystemdのunitをまとめるためのunit。  
`systemctl list-units -t target`で一覧をみれる。

* `multi-user.target`: the operation system is fully operational, without a graphical inteface.
* `graphical.target`: the operation system is fully operational, with a graphcial inteface.


## 参考

* [Understanding Systemd Units and Unit Files](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files)