# std::any

```rust
let x_any: Box<dyn Any> = Box::new(4u64);
```

* `x_any`はfat pointerで以下の2つのpointerを保持
  * 4へのraw pointer
  * `type_id()`へのvtableへのpointer

ここから`Any`は

* `is::<T>()`
* `downcast_ref::<T>()`
* `downcast_ref_mut::<T>`

のようにpointer経由で型を復元できる(dataと型を知ってるから)


## type_name
```rust
// 任意の型の名前を取得できる
assert_eq!(
    std::any::type_name::<Option<String>>(),
    "core::option::Option<alloc::string::String>",
);
```

* 返される文字列に依存しないようにする
  * なにも保証していない


## Blanket implementation

```rust
impl<T: 'static + ?Sized> Any for T {
  fn type_id(&self) -> TypeId {
    TypeId::of::<T>()
  }
}
```

* staticな`T`にはblanket implementationがある

