# Interrupt(割り込み)

* 原因の分類は流派があって統一されていない

## 発生原因

* HW. 周辺機器からの信号によって発生
* INT命令
* Page Fault(MMU起因)
* Abord(0助産とか)

## IDT(Interrupt  Descriptor Table)

* CPUが割り込み発生時に参照するデータ構造(配列)
  * 割り込みの識別子をindexとする
  * Descriptor(配列のエントリー)には割り込み処理を行うhandlerのアドレスが格納されている
* Kernelが作成し、特別な命令でCPUに設定する
  * lidt(Load Interrupt Descriptor Table)


## x86

* Fault
  * 例外ハンドラの処理後に例外を起こした命令を再試行する
* Trap
  * 例外を起こした命令の次の命令から再開される
  * INT3がこれ
* Abort
  * 例外処理中に処理できない例外が起きた等
