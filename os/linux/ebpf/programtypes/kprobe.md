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

* bpf programのkprobeへのattachはperf_event_open syscallが使われているらしい

## 仕組み

1. target addressのbytesをcopyする
2. target addressをbreakpoint instruction(int3等)に置き換える
  * optimizationが有効だとjmp命令になる 
3. probe対象の命令が実行される。breakpoint handlerがkprobeによるbreakpointかチェックして、そうならkprobeを実行する
4. copyしておいた命令を実行する
5. kprobeを消す際に元の命令に戻す

* kprobe実行中はpreemptionやinterruptsを無効にしている


## jprobe

関数の入口のみにbreak pointを仕掛けられる版


## 参考

- [Kernelのdoc](https://docs.kernel.org/trace/kprobes.html#kprobes-archs-supported)
- [LWN An introduction to KProbes](https://lwn.net/Articles/132196/)
