# Wait

## wait/sleepしたいユースケース

1. userspace process が `read()/ioctl()`
2. driver codeが実行されるが、deviceからデータがまた来ていない
3. processを待機させたいので、wait/sleep


## sleepとは

* `current` task_structの状態を`TASK_INTERRUPTIBLE` or `TASK_UNINTERRUPTIBLE`に変更
* runqueueから除外
* schedulerを呼び出す


## `wait_event_timeout()`

* condition成立 or timeoutまでsleepする
* 戻り値
  *  `0`: timeoutした
  * `>0`: 条件成立(timeoutまでの残り時間) 

```c
for (;;) {
    if (condition)
        break;

    prepare_to_wait(wq, TASK_INTERRUPTIBLE);

    if (timeout expired)
        break;

    schedule();  // ← CPU を完全に手放す
}
finish_wait(wq);
```


## `wait_event_interruptible_timeout()`

* task stateが`TASK_INTERRUPTIBLE`
  * signal(Ctrl-C)等で起こせる
