# RISC-V

## Registers

### 例外関連

* `scause`: 例外の種別を保持
* `stval`: 例外の付加情報(原因となったメモリアドレス等)
  * 4byte alignが前提。下位2bitにはmodeを表すflagを保持している
* `sepc`: 例外発生時のpc
* `sstatus`: 例外発生時の動作モード(U-Mode/S-Mode)

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


### 例外処理

例外が発生した際のRISC-Vの処理の流れ

1. `medeleg` registerの値から例外を処理する動作modeを決める
2. 例外発生時のCPUの状態を各CSRに保存する
3. `stvec` registerの値をpcにsetして、kernelの例外処理(例外handler)にjumpする
4. 例外handlerは`sscratch` registerを利用して、汎用register(例外発生時の実行状況)を保存し、例外の種類に応じた処理を行う
5. 例外処理が完了すると、保存していた実行状態を復元し、`sret` 命令で例外発生箇所から実行を再会する