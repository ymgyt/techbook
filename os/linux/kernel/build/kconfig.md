# kconfig

```sh
# defaultの.configを生成する
make defconfig

# distributionのbuild設定
/boot/config-$(uname -r)

# .configに新しいconfigをinteractiveに適用する
make oldconfig

# .configに新しいconfigをdefconfigに従って適用する
make olddefconfig
```

* `defconfig`
  * そのarchのdefault設定を適用する

* `oldconfig`
  * `.config`をベースに新規のconfigをinteractiveに追加していく

* `olddefconfig`
  * `.config`をベースに新規のconfigをdefconfigの値を自動で追加していく
  * `.config`を使いつつ、新規はdefault値を利用したい場合に便利

* `localmodconfig`
  * 現在実行中のconfigを取得したのち、`lsmod`して利用されているmoduleのみを有効にしてくれる
```


## Debian VM を最新にする

```sh
# guest からvirio-fs で共有したhostにcp
cp /boot/config-$(uname -r) /mnt/drivers/config-debian

```
