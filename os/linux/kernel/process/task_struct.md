# task_struct

## IDs

* `pid`: thread id
  * task_structでunique
  * `gettid()`
* `tgid`: thread group idでprocess idとして使う
  * `getpid()`
* `pgrp`: process group id
  * `getpgid()`
* `session`: sessoin id
  * `getsid()`


```
session(SID=1000)
│
├─ pgrp(PGID=1000)  ← bash
│   ├─ task_struct(pid=1000, tgid=1000) ← bashのメインスレッド
│   └─ task_struct(pid=1001, tgid=1000) ← bashの補助スレッド（例: job control）
│
└─ pgrp(PGID=1100)  ← sleep 100 &
    └─ task_struct(pid=1100, tgid=1100) 
```

## Session

* Session
  * Process group
    * Process


### Session

* ttyが紐づく
  * loginの単位
* ttyからの入力をforeground process groupに送る
* Session leaderをもつ

### Process group

* processのグループ
  * `ps aux | grep | bat`
* `setpgid()`で新しいgroupに入る
