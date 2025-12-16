# User and Group

* User
  * UIDをもつ

* Group
  * GIDをもつ


## UID/GID

* 0がroot
* 1000以上が一般user用
* UID:65534 を`nobody`として使う慣習がある
  * GID:65534は`nogroup`
  * https://www.linuxfromscratch.org/blfs/view/svn/postlfs/users.html

## System User

* daemonで利用するuser
* login shell, home-dirを作らない

## `/etc/passwd`

* systemのuser情報を保持
* `user-name:password:UID:GID:COMMENT:home-dir:login-shell`
  * COMMENTはUnixの名残でGECOS(General Electric Comprehensive Operating Supervisor)と言われている

* passwordはxとして、実体は`/etc/shadow`にある
* loginさせない場合はlogin-shellに`/sbin/nologin`や`/bin/false`を使う

## `/etc/group`

* systemのgroup情報を保持

## `/etc/login.defs`

## Group

```sh
# userが所属しているgroupの一覧
groups ymgyt
```
