# Memory consistency model

* SpecのChapter 14に説明がある

> A memory consistency model is
a set of rules specifying the values that can be returned by loads of memory.

* RVWMO(RISC-V Weak Memory Ordering)というmemory modelを使う
* base ISAはfence命令を定義している
  * A拡張がload-reserved/store-conditinalとatomic read-modify-write命令を定義している