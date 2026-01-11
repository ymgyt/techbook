# ELF

* `man elf`
* linkerによって作成され、loaderによって読まれる

## Memo

* sectionはlinkの単位
  * link時に各object fileにはsectionがある
  * linkerはELFにこれをまとめる?
* segmentは実行時(load)の単位
  * linkerがloaderのために作成する


## Sections

* linkerのための情報。kernelはみない
  * `.text`: 機械語
  * `.data`: 初期値のある変数
  * `.bss`: Block started by symbol
    * 初期値が未定義な変数
    * ELFにはsize情報だけ
    * 実行時にメモリにロードされるときにメモリを確保する?
  * `.rodata`
  * `.dynsym`
  * `.strtab`

## Segments

* ELF的にはprogram header
* 複数のsectionをまとめたもの
  * `.text`,`.rodata`,`.eh_frame` をまとめてRX
  * `.data`,`.got`,`bss` はRW
* mmapの単位
  * 仮想メモリのページ用の属性を保持

## Reference

* [ELFのオブジェクトファイル形式を生成する](https://tyfkda.github.io/blog/2020/04/20/elf-obj.html)
