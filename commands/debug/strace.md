# strace

* 実行するbinaryで発行されるsystem callを表示する

## Usage

```shell
# 出力結果をfileに書き出す
strace -T -o trace.log ./app
```

* `-o` 出力fileを指定
* `-T` system callの実行時間を表示(sec)
* `-f` 実行対象のプログラムがforkした場合、その子プロセスもtraceする


## 仕組み

```
function main():
  pid = fork()
  if pid == 0:
      # 子プロセス（トレース対象）
      ptrace(PTRACE_TRACEME, 0, NULL, NULL)
      execve("target_program", args, env)
      # execve が成功すると、target_program が実行される
  else:
      # 親プロセス（トレーサー）
      wait(pid)  # 子プロセスの開始を待つ
      while process_is_running(pid):
        # システムコールの呼び出しの直前または直後で停止する
        ptrace(PTRACE_SYSCALL, pid, 0, 0)
        wait(pid)  # 子プロセスがシステムコールに入るまで待つ

        # 必要に応じて、トレース対象のレジスタや情報を取得
        regs = ptrace(PTRACE_GETREGS, pid, 0, 0)
        print("システムコール番号:", regs.syscall_number)

        # システムコールの終了まで再び進める
        ptrace(PTRACE_SYSCALL, pid, 0, 0)
        wait(pid)
```

* `ptrace` を利用する
  * 対象プロセスのsystemcall 発生時にsignal?を送ってもらえるようになる?

