# kprobe

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
