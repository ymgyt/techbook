# ELF

* `man elf`
* linkerによって作成され、loaderによって読まれる

## Memo

* sectionはlinkの単位
  * link時に各object fileにはsectionがある
  * linkerはELFにこれをまとめる?
* segmentは実行時(load)の単位
  * linkerがloaderのために作成する
