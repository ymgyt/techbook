#	BPF_PROG_TYPE_TRACEPOINT

* 関数(probe)をcodeの決められた箇所で実行するhookを提供する
  * 静的
* `/sys/kernel/debug/tracing/events`でみれる 
  * `/sys/kernel/tracing/available_events` という説も

* kprobeと違い、kernelのversion間で維持されるapiとされている

## 参考

* [Kernel Doc: Using the Linux Kernel Tracepoints](https://docs.kernel.org/trace/tracepoints.html)
