# Unit

systemdの操作単位。processの起動やfile systemのmount等のtaskを抽象化したもの。  
格納場所は

* `/lib/systemd/system/`
* `/etc/systemd/system/`
  * こちらのほうが同名fileの優先度が高い。基本はここらしい。

`man systemd.unit`

## Unit Type

* service: serviceの設定sysVの代替
* target: startup
* socket
* mount/automount: mount pointに関する情報  
* slice: cgroupの設定
* timer: cronの代替

## Directives

unitのtypeに関わらず共通で設定できる項目。

### Unit

```text
[Unit]
Description=Foo Service
After=network.target remote-fs.target nss-lookup.target
Documentation=https://docs.ymgyt.io
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run
```

* `ConditionPathExists`: pathの存在で制御できる

### Install

```text
[Unit]
# ...

[Service]
# ...

[Install]
Wants=a.target b.target
WantedBy=multi-user.target
Alias=sshd.service
```

* `Requires`: 依存するservice。依存先が起動に失敗した場合はunitを起動しない。
* `Wants`: このserviceが依存するservice。起動していなければsystemdが起動する。起動に失敗したら無視する
  * 起動の順番はAfter,Beforeで指定する。指定がないとWantsと同時に起動される
* `After`: このunitよりも先に起動するunit
* `Before`: このunitよりも後に起動するunit

* `WantedBy`: なにかを実際にinstallするわけではなく、unitの有効無効の制御
  *  `systemctl enable`した際に`/etc/systemd/system/multi-user.target.wants/`にsymlinkが作成されることに対応する
* `Also`: enableした際に同時に操作?するunit
* `Alias`: serviceのalias. sshとsshdがdistroで揺らぐ場合があったりするらしいのでこれで吸収できる

