# ptrace

* あるプロセスが別のプロセスを監視、制御するためのkernel API

* taskはtracer-traceeの関係を保持できる


## `PTRACE_SYSCALL`

```rust
ptrace(PTRACE_SYSCALL, child, 0, 0);
```

* Child processの次のsyscallでとめる
* Tracer processはsyscall直前の状態で`waitpid()`から返る
