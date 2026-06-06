# perf events

* 実行するlinuxのversionと同じversionをinstallする必要がある
  * aptだと`apt-get install linux-tools-$(uname -r)`

* `linux/tools/perf/Documentation`にdocがある
* `perf_event_open` syscallを呼んでいる
  * kernelがeventsをring bufferに書き込む
  * `perf`がring bufferから読んで表示している

## perf command

```sh
# [k]がついているのはkernelの関数
perf top

perf list
```
