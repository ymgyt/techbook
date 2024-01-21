# std::any

```rust
// 任意の型の名前を取得できる
assert_eq!(
    std::any::type_name::<Option<String>>(),
    "core::option::Option<alloc::string::String>",
);
```

* 返される文字列に依存しないようにする
  * なにも保証していない
