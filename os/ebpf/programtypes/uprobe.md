# uprobe

* userspaceでのdynamic traceのための仕組み
* 命令をbreakpointに書き換える仕組みはkprobeと同じ
* perf_event_open()で制御する?
  * kprobe同様、perf_event_openでbpf programをattachしているらしい
