# Driver Device

DriverとDeviceのinterface?関連について

* Driverがdeviceを制御するとはdeviceのregisterを操作するという意味

## Device Registerへのアクセス

以下2種類の方法がある

* MMIO
* I/O Port


### MMIO

* Memory mapped IO
* 物理アドレス空間の一部をDevice Register領域に割り当てる
  * 実装例は`ioremap`を参照
* メモリアクセス(トランザクション)は必ずメモリ(SDRAM)に届くわけではなく、別ハードに送ることができる


### I/O Port

* メモリとは別のアドレス空間でやりとりする
