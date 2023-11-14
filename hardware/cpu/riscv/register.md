# RISC-V Registers

* RV32Iでは32個ある
  * pcは汎用registerではない
    * ARM-32ではpcがregisterだった

* `x0/zero` 常にzeroを返す
* `x1/ra` return address
* `x2/sp` stack pointer
* `x3/gp`
* `x4/tp`
* `x5/t0` ~ `x7/t2`
* `x8/s0/fp`
* `x9/s1`
* `x10/a0` ~ `x17/a7` 関数の引数
* `x18/s2` ~ `x27/s11`
* `x28/t3` ~ `x31/t6` 一時register

## 例外関連

* `scause`: 例外の種別を保持
* `stval`: 例外の付加情報(原因となったメモリアドレス等)
  * 4byte alignが前提。下位2bitにはmodeを表すflagを保持している
* `sepc`: 例外発生時のpc
* `sstatus`: 例外発生時の動作モード(U-Mode/S-Mode)
