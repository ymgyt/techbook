# RISC-V

* リトルエンディアン
* [Specifications](https://riscv.org/technical/specifications/)

## 命令セット

基本命令セットと拡張命令で構成されている。

### 基本命令セット

* `RV32I` 32bit address 整数命令
* `RV32E` 32bit address 組み込み向け命令
* `RV64I` 64bit address 整数命令
* `RV128I` 128bit address 整数命令

メモリモデルも決まっている

* `RVWMO` メモリモデル
  * メモリアクセスに関する仕様

### 拡張命令

* `A` atomic 拡張
* `M` 掛け算、割り算
* 浮動小数点
  * F,D,L,Q
* `N` User levelの割込
* `S` Super visor mode
* `P` packed SIMD
* `V` Vector
* `Zicsr` csr制御命令
* `Zifencei` フェンス関連

便利表記

* `G`
  * I, M, A, F, D, Zicsr, Zifencei
  * RV64GCがよく使われているらしい(Cは圧縮)

## 特権mode

常にいずれかのmodeで動作している。

* Machine Mode(M-Mode)
  * すべての機能を利用できる
* Supervisor Mode(S-Mode)
  * LinuxのようなOS向け
* User Mode(U-Mode)
  * applicationの動作mode

