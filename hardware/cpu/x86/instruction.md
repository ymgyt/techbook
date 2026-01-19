# x86 Instruction

* CPUID
  * CPUコアの情報を取得できる

* `LIDT`(Load Interrupt Descriptor Table)
  * IDTのアドレスをLoadする

* `SYSCALL`
  * ジャンプ、特権遷移、レジスタ切り替えを1命令で行う
    * 事前にkernelがMSRに設定したアドレスに飛んでsystem callを行う
    * Ring3 -> Ring1
