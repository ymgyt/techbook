# BPF_PROG_TYPE_KPROBE

* sysfs経由で設定できる..?
* このあたりで情報をみれる
  * `/sys/kernel/debug/tracing/events/[uk]probe/{probename,id}`
  * `/sys/kernel/debug/tracing/kprobe_events`
* kernelの`CONFIG_KPROBES=y`が必要

* handler
  * pre-handler routine
  * post-handler routine
  * fault-handler routine


## jprobe

関数の入口のみにbreak pointを仕掛けられる版
=======
## 参考

- [Kernelのdoc](https://docs.kernel.org/trace/kprobes.html#kprobes-archs-supported)
