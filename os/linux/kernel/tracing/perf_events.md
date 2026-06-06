# perf events

*  perf provides rich generalized abstractions over hardware specific capabilities. 
  * 特定のCPU/hardware特有の機能を抽象化している..?
* kernelのtools/perfで管理されている
  * perf_events subsystemへのfront end

* `perf_event_open(2)` systemcall で操作する

* 別名
  * Performance Counters for Linux(PCL)
  * Linux Performance Events(LPE)
  * Performance monitoring Counter(PMC)

* メンタルモデル
  * なんらかのeventが発生したら、counterかring bufferに書き込まれる
  * これを出力したり有効化するのがperf

* eBPFとの関係
  * perf_eventsもebpfのhookpointの一つ
    * `BPF_PROG_TYPE_PERF_EVENT`

## events

perf_events が扱うevent

* hardware events
  * CPUに内蔵されたPMU(Performance Monitoring Unit)が提供するevent
  * CPUサイクル数、実行命令数、キャッシュミス等

* software events
  * kernelが提供するevent
  * コンテキストスイッチ数や、ページフォルト数

* tracepoint
  * perf_eventsを介して、tracepointにアクセスできる

* hardware breakpoint

## `perf` command

```sh
# event sourceを出力
perf list
```


## 参考

* [Wiki](https://perf.wiki.kernel.org/index.php/Main_Page)
  * [Useful Links](https://perf.wiki.kernel.org/index.php/Useful_Links)
