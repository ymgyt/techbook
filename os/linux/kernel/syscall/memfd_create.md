# memfd_create

* 匿名fileを作りfdを返す
  * fdがあるので、fileとして扱える(read/write)
  * pathはない
  * `/proc/<pid>/fd/<n>`は生える
* 実体はメモリ上にある
  * tmpfsみたいな
* fdがあるので他プロセスと共有して、`mmap()`することでプロセス間メモリ共有に使える
