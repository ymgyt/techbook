# kernel config

(kernel option)

* configを確認したい場合
  * `zcat /proc/config.gz`

* `CONFIG_FRAME_POINTER`
  * registerのbase pointerを壊さない
  * 一時的に違う目的に利用しない
    * これを前提にできれば、stack traceを辿れる

* `CONFIG_UPROBE_EVENTS`
  * uprobeの有効化

* `CONFIG_IKCONFIG`
  * 適用された`.config`をimageに含める

* `CONFIG_SYSFS`
  * sysfs(`/sys`) を有効にする
