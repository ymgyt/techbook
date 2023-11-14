# 例外

RISC-Vの例外には同期例外と割り込みがある。


## 同期例外

命令を実行した結果生じる。 
発生原因として以下がある。

(M-Modeが前提)

* access fault
  * ROMにstoreしようとした場合等
* break point 
  * ebreak命令を実行 
* ecall命令を実行
* 無効なopcodeをdecode
* 不正なalignment


## 割り込み

命令streamの処理とは無関係に生じる


### 例外処理

(defaultの設定では)全ての例外はM-modeの例外ハンドラで処理される。  
ただし、例外処理をS-modeに渡す仕組みがある(例外委任機構)   
`mideleg`(Machine Interrupt Delegation) CSRがどの割り込みをS-modeに委任するか制御している。  
`medeleg`(Machine Exception Delegation)が同期例外の委任CSR


例外が発生した際のRISC-Vの処理の流れ

1. `medeleg` registerの値から例外を処理する動作modeを決める
2. 例外発生時のCPUの状態を各CSRに保存する
  * 例外を起こした命令のpcが`sepc`に保存される
  * 例外原因が`scause`に設定される
3. `stvec` registerの値をpcにsetして、kernelの例外処理(例外handler)にjumpする
4. 例外handlerは`sscratch` registerを利用して、汎用register(例外発生時の実行状況)を保存し、例外の種類に応じた処理を行う
5. 例外処理が完了すると、保存していた実行状態を復元し、`sret` 命令で例外発生箇所から実行を再会する