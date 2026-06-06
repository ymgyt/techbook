# process

## `Stdio`

* `Stdio::inherit()`
  * 子プロセスの標準入出力を親プロセスのそれに接続する
  * 子プロセスの出力は、terminalに表示され、terminal の入力も読める
* `Stdio::piped()`
  * 子プロセスの標準入出力をプログラム的に制御できる
