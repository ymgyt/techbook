# Virtualization

## Memo

* CPUにレジスター郡をまるまる保存して切り替えられるModeができた
* CPU Register, RAM, Page Tableを用意して、ProgramCounterをOSのentry pointにすればGuest OSが動き出す
  * VM-Enter
  * CPUはVM Modeであるとわかっている
* CPUはGuestのレジスタ群を保存してHostのレジスタ群を復帰させることで制御をHostにもどせる(VM-Exit)

* メモリアクセス
  * Guestの仮想アドレス-> Guest物理アドレスの変換後にVM ModeだとさらにHostが用意したtableでGuest物理-> Host物理の変換が行われる

* I/O
  * GPA(Guest物理)のMMIOに対応するアドレス範囲をHPAでアクセス禁止にしておく
  * GuestがMMIO(NIC書き込み等)を実行すると例外で制御がHostにもどる

* 割り込み
  1. Guestをとめる(VM-Exit)
  2. HostがIDTからhandlerを実行
  3. Guestに　通知すると判断
  4. Guest CPUに割り込みがおきる予約をする
  5. VM-Entry
  6. Guest側で割り込み処理が走る

* CPU命令
  * VMLAUNCH(初回)
  * VMRESUME(2回目以降)
    * 事前にVMXONを実行しておく必要がある?
  * VM-Exitは命令でなくCPUの動作


## 質問リスト

* VM-Entry/Exitは誰の概念?(KVM,Intel, x86-64 ISA)
