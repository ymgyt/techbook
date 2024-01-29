# Instruction

## x86(Intel/AMD)

Intel記法。(destが第一引数)

- `jmp Label`: 無条件分岐
- `je`: 条件分岐
- `call`: 関数呼び出し
- `ret`: 関数リターン

- `mov rax, [rbx]`: メモリ(rbx)からraxにload
- `mov [rbx], rax`: メモリへのstore

- `add rax, rbx`: rax = rax + rbx

- `int`: system call
- `sysenter`: system call
- `syscall`: system call
- `iret`: return system call
- `sysexit`: return system call
- `sysret`: return system call

## Arm

### v8

- `b Label`: 無条件分岐 
- `b.eq`: 条件分岐
- `bl`: 関数呼び出し
- `ret`: 関数リターン
- `ldr x1 [x2]`: x2で指定するメモリの値をx1にload
- `str x1, [x2]`: x1をメモリ(x2)へのstore
- `mov x5, x6`: x6 regからx5 regにcopy

- `add x5, x6, x7`: x5 = x6 + x7

- `svc`: system call
- `hvc`: system call
- `smc`: system call
- `eret`: return system call


## RISC-V

- riscv側参照
