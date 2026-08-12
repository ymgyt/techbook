# timer

* `kernel/timers.c`
* network/block のtimeout登録を精度を犠牲にしつつ、効率的に管理できる

```text
jiffies = 1000

1001: [A, B]
1002: [C]
1003: []
1004: [D, E, F]
...
```
のように、jiffiesベースで精度を犠牲にしつつ、複数callbackを管理できる

```text
A = 4,000,013 ns
B = 4,000,927 ns
C = 4,001,003 ns
```

のようにしない。
