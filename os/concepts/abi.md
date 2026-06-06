# ABI

Application binary interface。

* OSとapplication(binary)との規約
* systemcallを呼ぶ際の引数の渡し方
  * 第一引数はどのregister
  * CPU instruction

* CPUが同じでもLinuxのbinaryをFreeBSDで動かせないのは、systemcallの呼び方が違いうるから
  * emulationしない前提

* POSIXはソースコードレベルの規約なので、POSIXに従えばcompileすればLinux, FreeBSDで動く
