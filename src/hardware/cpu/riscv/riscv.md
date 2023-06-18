# RISC-V

## 例外

RISC-Vの例外には同期例外と割り込みがある。


### 同期例外

命令を実行した結果生じる。 
発生原因として以下がある。

* access fault
  * ROMにstoreしようとした場合等
* break point 
  * ebreak命令を実行 
* ecall命令を実行
* 無効なopcodeをdecode
* 不正なalignment


### 割り込み

命令streamの処理とは無関係に生じる