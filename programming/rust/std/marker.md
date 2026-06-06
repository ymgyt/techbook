# marker

## `PhantomData`

```rust
use std::marker::PhantomData;
use std::rc::Rc;

struct OwnsLike<T> {
    _marker: PhantomData<T>,
}

struct TypeOnly<T> {
    _marker: PhantomData<fn() -> T>,
}
```

`PhantomData<T>`ではなく、`PhantomData<fn() -> T>` と書く場合がある。その際のモチベーション

* 型としてはTで区別したいが、Tのauto traitに依存したくない
   * Tが`Rc<()>`の場合、`!Sync`, `!Send` になるが、値としてはTをもたないのに、`!Sync` になると困る
   * `fn() -> T` は関数pointerなので、Sync + Sendになる

* `fn(T) -> ()` はTのcontravariant

### T の所有を宣言したい場合

```rust
use std::marker::PhantomData;

struct MyBox<T> {
    ptr: *mut T,
    _owns: PhantomData<T>,
}

impl<T> Drop for MyBox<T> {
    fn drop(&mut self) {
        unsafe {
            // ptr の先にある T を破棄する
            drop(Box::from_raw(self.ptr));
        }
    }
}
```

この甩に実体としてはpointerを保持しているが、compilerにdrop時にさわることを宣言したい場合に使う

## `PhantomPinned`

* `!Unpin`(Unpinをopt out)したいときに使う

```rust
use std::marker::PhantomPinned;

struct SelfRef {
    x: u32,
    ptr: *const u32,
    _pinned: PhantomPinned,
}
```

これで`SelfRef`は`!Unpin`になる。

## `Send`と`Sync`

型`T`が別のthreadに安全に渡せるなら`Send`、`&T`が`Send`なら`T`は`Sync`。
