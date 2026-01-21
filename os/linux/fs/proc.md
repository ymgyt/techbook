# proc

* `man 5 proc`
* `/proc/self/exe`
  * 実行プロセス自身のsymblic link

## `/proc/<pid>/maps`

```sh
cat /proc/self/maps

563d473e5000-563d473fb000 r--p 00000000 fe:00 14185163                   /nix/store/v4q3154vdc83fxsal9syg9yppshdljyk-coreutils-full-9.8/bin/coreutils
```

`[start]-[end] [perms] [offset] [dev] [inode] [pathname`

* start-end: 仮想アドレスの範囲

* perms
  * r: readable, w: writable, x: executable,
  * p: private,  s: shared

* offset: 対応するfileのどこからmapされているか

* dev: major:minor device番号
  * `00:00` 匿名mapping ([heap], [stack])

* inode: mapしているfileのinode.
  * 複数プロセスでinodeが同じなら同じファイルをみている

* pathname: mapされているfileのpath
  * 匿名mappingの場合は`[heap]`
