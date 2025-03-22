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


## Dependency

* `foo.service.wants/` directory配下に作成されたsymlinkがあると暗黙的に`Wants=`に追加され
  * `foo.service.requires/`も同様
  * 元fileに変更を加えることなく、hookできる利点がある

### Implicit dependency

unitのtypeや設定に応じて暗黙的に`Requires=`や`After=`が追加される仕様がある。これのおかげで設定fileがsimpleになるらしい。


## 設定の上書き

* `foo.service.d` directoryがあり、`.conf`で終わるfileがあると`foo.service` の上書きとして参照される。順番は `man systemd.unit` 参照。