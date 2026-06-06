# output

* `echo`: 引数を結果として返す
  * pipeでの利用が主

* `print`: stdoutへの出力、戻り値はnull
  *  `print "hello" | describe` はnothing

* `log`
  * `NU_LOG_LEVEL=DEBUG nu script.nu` でlog level制御できる
    * defaultはinfo

```nu
use std log

def main [] {
  log debug    "msg"
  log info     "msg"
  log warning  "msg"
  log error    "msg"
  log critical "msg"

  # これも可能
  use std log info
  info "msg"
}
```
