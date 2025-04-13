# Boot Sequence

1. BIOS
2. ブートセクタ
  * 512 byteしかない(フロッピーとかもある)
  * filesystemなんか読めない
3. Bootloader
4. Kernel

## MBR (Master Boot Record)

* HDの先頭セクタに書かれている512 byteの領域
* DL reg に自分自信がどこ(HD,フロッピー)から読まれかをBIOSが書いてくれる
