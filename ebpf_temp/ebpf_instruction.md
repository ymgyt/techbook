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

| Register | Description   |
| ---      | ---           |
| R0       | 戻り値        |
| R1 - R5  | 引数          |
| R6 - R9  | 汎用          |
| R10      | Frame pointer |


## 外部関数呼び出し

* 事前に登録済みのkernelの関数を呼び出せる
