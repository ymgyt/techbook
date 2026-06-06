# top

```sh
# 指定されたprocessをthreadごとにみる
top -p $(pidof foo) -H
```

* `-H`: threadごとの表示

## 見方

```sh
#     現在時刻     uptime login user              1分   5分   15分
top - 21:32:23 up  1:14,  2 users,  load average: 0.50, 0.21, 0.13
# threadの状態
Threads:  22 total,   0 running,  22 sleeping,   0 stopped,   0 zombie
#         user     kernel   低優先  idle      I/O待    割り込み
%Cpu(s):  0.5 us,  0.5 sy,  0.2 ni, 98.2 id,  0.1 wa,  0.4 hi,  0.1 si,  0.0 st
```


