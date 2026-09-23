# ld-linux.so

* `man ld-linux.so`

## 共有libの検索

* `PT_DYNAMIC` segment のentryから`NEEDED` を探す

```sh
 readelf --dynamic /home/ymgyt/.nix-profile/bin/synd | rg NEEDED
 0x0000000000000001 (NEEDED)             Shared library: [libgcc_s.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libm.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x0000000000000001 (NEEDED)             Shared library: [ld-linux-x86-64.so.2]
```

* 値に`/` が入っていた場合は相対、絶対パスとして探しに行く
* `/`が入っていない場合は、指定dirから探しにいく

* 検索dirの指定方法(優先度高い順)
  * `PT_DYNAMIC` segmentの `DT_RPATH` の値
  * env `LD_LIBRARY_PATH`
  * `PT_DYNAMIC` segmentの `DT_RUNPATH` の値
  * `/etc/ld.so.cache` の中身
    * `/etc/ld.so.conf` をcompileする
  * `/lib`, `/usr/lib`, `/lib64`, `/usr/lib64`

## Environment Variables

* `LD_PRELOAD`
  * 指定した共有libを読み込める

* `LD_DEBUG`
  * debugの挙動を制御できる
  * `symbols`, `all`

* `LD_AUDIT`
  * 監査用hookを設定できる
