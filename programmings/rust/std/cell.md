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
