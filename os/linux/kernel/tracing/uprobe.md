# uprobe

* userspaceでのdynamic traceのための仕組み
  * application の命令をint3(x86)に書き換える
  * 例外をcatchしたらuprobeの処理を実行してもどってくる

* perf_event_open()で制御する?
  * kprobe同様、perf_event_openでbpf programをattachしているらしい

* 実行file pathベースで指定する
  * 実行fileを同じくするすべてのprocessが影響をうける
