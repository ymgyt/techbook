# vtable

* traitで定義されたmethodを実装する関数へのpointerを一覧にしたデータ構造
* trait objectに参照される
  * trait ojectはdataとvtableへの2 pointerをもつ
* `trait Draw: Shape`のように継承関係があっても、ひとつのvtableになる。vtable -> vtableのようなことはしない
* `Box<dyn Trait>` がscopeを抜けるときに実行されるdropの実装もvtableに格納される
* 型のmeta情報(size, align)も保持されているらしい

* x86だと`call qword ptr [rip + .L__unnamed_2+24]` のようになるらしい?
  * `L__unmaed_2`がvtableで`+24`がoffset

## 擬似コード

```rust
// obj.method()
(obj.vtable.method_pointer)(obj.data_pointer)
```
