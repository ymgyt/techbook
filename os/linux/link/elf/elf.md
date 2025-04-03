# ELF

* `man elf`
* linkerによって作成され、loaderによって読まれる

## Memo

* sectionはlinkの単位
  * link時に各object fileにはsectionがある
  * linkerはELFにこれをまとめる?
* segmentは実行時(load)の単位
  * linkerがloaderのために作成する


## Reference

* [ELFのオブジェクトファイル形式を生成する](https://tyfkda.github.io/blog/2020/04/20/elf-obj.html)
