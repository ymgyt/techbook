# UEFI (Unified Extensible Firmware Interface) 

あくまで仕様だが、BIOSの後継プログラム的な使われ方をする。

## 役割

1. 電源ON
1. CPUはマザボードの不揮発性メモリ(ROM)にのっているプログラム(BIOS)を実行。(PCを規定の番地にセット)
1. BIOSはCPUのcache,registerをclear
1. マザーボード上のコントローラ(CPU,メモリ,キーボード、割り込み,...)の状況確認
1. POST(Power On Self Test)を実行して周辺機器の初期化、設定
1. OSが記録されている媒体の特定番地を実行
1. OSがメモリにのって制御開始

## 参考

* [UEFI Specification 2.9](https://uefi.org/sites/default/files/resources/UEFI_Spec_2_9_2021_03_18.pdf)
* [旧BIOSを進化させたUEFI、その基本を解説](https://www.pc-koubou.jp/magazine/1257)
