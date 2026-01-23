# Kernel Space

* Process毎に仮想アドレス<->物理アドレスの対応は違う
  * `CR3` registerが指すページテーブルが違う
* しかし、Kernel spaceはすべて同じ物理アドレスにマッピングされる


## Kernel Stack

* Kernel spaceは全プロセスで共通だが、stackはthread(`task_struct`)毎に違う
