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


## RISC-V

- `j Label`: 無条件分岐
- `beq`: 条件分岐
- `jal`: 関数呼び出し
- `ret`: 関数リターン
- `ld x1 (x2)`: メモリ(x2)からのload
- `sd x1, (x2)`: メモリへのstore
- `mv x5, x6`: x6 regからx5 regにcopy

- `add x5, x6, x7`: x5 = x6 + x7