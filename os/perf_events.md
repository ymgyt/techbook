# perf events

*  perf provides rich generalized abstractions over hardware specific capabilities. 
  * 特定のCPU/hardware特有の機能を抽象化している..?
* kernelのtools/perfで管理されている
  * perf_events subsystemへのfront end

* 別名
  * Performance Counters for Linux(PCL)
  * Linux Performance Events(LPE)
  * Performance monitoring Counter(PMC)

* メンタルモデル
  * なんらかのeventが発生したら、counterかring bufferに書き込まれる
  * これを出力したり有効化するのがperf

## `perf` command

```sh
# event sourceを出力
perf list
```


## 参考

* [Wiki](https://perf.wiki.kernel.org/index.php/Main_Page)
  * [Useful Links](https://perf.wiki.kernel.org/index.php/Useful_Links)
