# メモリマップ

* 物理メモリアドレス空間のすべてをRAMのアクセスとしてkernelが自由に使えるわけではない
  * Memory Maped I/Oに使われる場合
    * PCIeのBAR領域
      * RAMの穴にみえる
      * PCI hole
  * RAMとして使えるがFirmwareがのっている
    * BIOSのデータ構造がのっている
    * ACPI
    * UEFI runtime service

* どのアドレスが利用可能かはBIOSから教えてもらえる

* Memmory Remapping
  * 1-10あったとして、PCIが5-10使っていると、RAMとしてはあるのに、RAMとして参照できないアドレスができてしまう
    * 参照するとMemory Maped I/Oになる
  * 10-16の物理アドレスをRAMの5-10に割り当てれば無駄なく使える
    * 変換はメモリコントローラーが行う(CPUは関与せず)
