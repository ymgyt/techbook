# BPF_PROG_TYPE_KPROBE

* sysfs経由で設定できる..?
* このあたりで情報をみれる
  * `/sys/kernel/debug/tracing/events/[uk]probe/{probename,id}`
  * `/sys/kernel/debug/tracing/kprobe_events`


## jprobe

関数の入口のみにbreak pointを仕掛けられる版
