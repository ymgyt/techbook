# bpftrace

```sh
# 情報の確認
bpftrace --info

bpftrace -e 'PROGRAM'

# probeの検索
bpftrace -l 'tracepoint:*'
```

* `-e` 引数のプログラムを実行する
* `-d` debug modeを有効化

## tracepoints

```sh
bpftrace -e `tracepoint:<category>:<event>`


bpftrace -e 'tracepoint:syscalls:sys_enter_execve { 
  printf("execve: pid=%d command=%
s\n", pid, str(args->filename)); 
  }'
```
