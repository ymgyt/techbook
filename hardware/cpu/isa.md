# ISA

Instruction Set Architecture
ISはあるCPUが理解できる命令の集合。  
Aがつくのは、割込や仮想記憶といった機能を利用するための仕組み/仕様もCPUで異なっていることを含意している。  

Hardwareと機械語softwareはどのようにつながるかを規定。  
Pipelineの段数やOutout order実行はISAには含まれない。

## ISAが決めていること

* 命令の種類や表現方法
* 汎用registerの仕様
  * 数、長さ、命令ごとに利用できる種類
* メモリアドレッシング
  * 命令ともいえるが、どの命令でどのサイズのメモリにアクセスするか
* 仮想アドレス(pagingのデータ構造)
* 割込、例外仕様
* Debug仕様

## ISAの種類

* x86
  * Intel/AMD
  * 32bitはIA32, 64bitをx86_64と呼んだりも

* ARM
  * Smartphoneでシェア。
  * ARMv8では64bitアドレス空間(AArch64)をサポート。

* MIPS
  * RISC
  * ヘネシー先生が開発
* Power
  * IBM
* SPARC
  * サンマイクロ

* RISC-V
  * オレたちのRISC-V
