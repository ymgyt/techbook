# std::cell

## Cell

* `std::cell::Cell<T>`はTを内部可変にする(`&T`で値を変更できる)
* `T`にcopyを要求
* `AtomicInt`等のsingle thread版


## RefCell

* `std::cell::RefCell<T>`はTを内部可変にする
  * Tの一部のfieldを変更できるのがCellとの違い
  * shared ref, exclude refをruntimeに判定する
* `std::sync::RwLock`のsingle thread版


## UnsafeCell

* `&T`がいきている間、`T`が変化しない前提でRustは最適化を適用する
* `&UnsafeCell<T>`はその最適化をopt-outする
  * compilerがinterior mutabilityをrespectする
* `Cell`,`RefCell`といった、interior mutability提供型は内部でこれを使っている
* `&mut` が唯一であるとう保障はUnsafeCellでも有効
* data racesを避けるのは使う側の責務で、なにか特別なことをしてくれるわけではない
