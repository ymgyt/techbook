# Registeres

* `RLFAGS` (CPUの状態)
  * 演算結果
  * 制御系
    * `IF`: 割込み許可フラグ

* `CR0` (Control Register 0)
* `CR2`
  * 最後にpage faultを起こした仮想アドレス
* `CR3`
  * page tableのaddress

* `IDTR`
  * IDTのaddress

* `GDTR`
  * GDTのaddressを保持

* `TR` (Task Register)
  * GDTのTSS descriptorのindex

## MSR (Model Specific Register)

* `rdmsr/wrmsr`という命令で操作する(`mov`ではない)

* `IA32_LSTAR`: syscall時のjump先アドレスを格納
  * Long System Target Address Register

## GDT

* メモリ上にあるdescriptorの配列
  * kernelが用意して
* メモリ上の重要構造を参照するという設計思想
* descriptors
  * TSS: TSSのaddress
  * descriptorは8byteだけど、TSS descriptorは16byteなので2entry使ってる

## TSS

* メモリ上にあるstruct
  * CPUが割り込み時に参照する非常用スタックポインターの表
* CPU毎に保持
* TR registerから参照できる
  * 正確にはTR -> GDT -> TSS
* 割り込みhandlerが利用するstackに関する情報をもっている(IST)

### IST

* TSS内にある配列
* 7本のstack pointer
* IDTのentryがどのISTを使うかのindexをもっている
