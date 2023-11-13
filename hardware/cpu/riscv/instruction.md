# RISC-V Instruction

## ECALL

KernelからSBIの機能を実行できる..?

## 擬似

assemblerでは使えるが内部的には別の命令で実現されている命令

* `mv rd, rs1`
  * `rs1`の内容を`rd`にcopyする
  * `addi rd, rs1, 0`のようにaddと0の加算で実現される