# unsafe

## `unsafe` fn

```rust
pub unsafe fn decr(&self) {
    self.some_usize -= 1; 
}
```

* 関数に付与されたunsafeは呼び出し側が関数が前提にしているinvariantsが保たれていることを保証する必要がある
* 関数のunsafeは関数body内にunsafe blockがあるかとは関係しない


## `unsafe {}`

* raw pointerのdereference
* unsafe fnの呼び出し

## raw pointers

* `*const T`
* `*mut T`
* 参照との違いは
  * lifetimeをもたない
* raw pointerのほうが適用されるruleが緩いので、`unsafe {}`の外でも、参照からraw pointerへの変換は実行できる。
* pointerから`&`への変換では
  * `unsafe { &*ptr }`のようによく書く。一回dereferenceしているので、unsafeが必要。

### 使い分け

* `*mut T`と(`*const T`, `std::ptr::NonNull<T>`)の違いは、`*mut T`はTについてinvariant。(他方はcovariant)
