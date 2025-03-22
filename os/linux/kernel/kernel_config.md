# kernel config

(kernel option)

* configを確認したい場合
  * `zcat /proc/config.gz`

* `CONFIG_FRAME_POINTER`
  * registerのbase pointerを壊さない
  * 一時的に違う目的に利用しない
    * これを前提にできれば、stack traceを辿れる

