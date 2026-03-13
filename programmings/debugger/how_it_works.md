# Debugger How It Works

## Forkするケース

debug対象がまだ起動していないプロセス

```rust
match unsafe { fork() }? {
    ForkResult::Parent { child } => {
        waitpid(child, None)?;
    }
    ForkResult::Child => {
        // ここでkernelに親processにtraceされていることを通知
        ptrace::traceme()?;
        // ptraceされているのでここで実行が止まる(tracerに制御がうつる)
        execvp(&cmd, &argv)?;
    }
}
```

* 親process(tracer)は`waitpid()`でkernelからtraceeの状態変化が通知されるのをまつ
