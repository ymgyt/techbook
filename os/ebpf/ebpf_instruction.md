# eBPF Instruction

## Instruction format

```
struct ebpf_insn {
    u8    code;       /* オペコード */
    u8    dst_reg:4;  /* ディスティネーションレジスタ */
    u8    src_reg:4;  /* ソースレジスタ */
    s16   off;        /* オフセット */
    s32   imm;        /* 即値 */
};
```

## Register

| Register | Description              | Save           |
| ---      | ---                      |                |
| R0       | 戻り値                   |                |
| R1 - R5  | 引数                     |                |
| R6 - R9  | 汎用                     | Callee saved   |
| R10      | Frame pointer(read only) |                |

* register幅は64bit
* R0
  * 関数呼び出し時のreturn value
  * bpf programのexit value 
* R1
  * program起動時にinputへのmemory addressをもつ

* R1-R5
  * numberか、stackへのpointerしか保持できない 
  * memory accessはまずstackへのloadを行う必要がある

## Stack

512 byte stack

## 外部関数呼び出し

* 事前に登録済みのkernelの関数を呼び出せる
