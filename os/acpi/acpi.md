# ACPI

Advanced Configuration and Power Interface Specification

* Firmware(BIOS/UEFI)がhardwareの構成、電源制御、デバイス操作方法をOSに渡すための仕様

## ACPI Table

* OS起動時にKernelにhardware関連の情報を教える
  * PCI deviceの割込み
  * メモリマップ
  * CPU温度監視情報

* BIOS(UEFI?)がメモリ上に生成する
　* 先頭アドレスはRSDP(Root System Description Pointer)といわれる
  * 特定の物理アドレスにあることが仕様で決まっている?

### Table Entry

* MCFG: PCIeのConfiguration Spaceのアドレスがのっている?
