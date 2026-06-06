# std::mem

## MaybeUninit

* Optionのunsafe版
* メモリが初期化されていない状態を表現
  * 型のinvariantをprogrammerが守らないといけない
    * reference(`&`)がalignされていて、nullでない等

* `MaybeUninit::uninit()`で初期化する
* `write()`で書き込む
* `assume_init_read()`で読む
  * 事前に正しい値をwriteするのはprogrammerの責任
* `assume_init_drop()`で明示的にinnerをdropする必要がある
  * MaybeUninitはdrop時にinnerをdropしない?