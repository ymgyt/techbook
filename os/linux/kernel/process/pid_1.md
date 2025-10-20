# PID 1

* Signal handling
  * SIGKILL/SIGSTOP以外を無視
* 孤児プロセスをwaitする

## Signal

Kernelに特別扱いされるので自分でsignal handlingの設定が必要

## Docker

containerは独立したPID namaspaceで動作するのでPID 1になる。
bashは自前で、SIGTERMのハンドラーを登録しないので、containerでbash -> appのような起動をすると、docker stopのようなruntimeからのシグナルがbashに握りつぶされる。
ので、`--init` やtinyとかを必要なら使う
