# HashMap

## Entry Api

```rust
h.entry("key")
    .and_modify(|x: &mut Value| x += 1)
    .or_insert(a);
```

* `and_modify()`で既存のvalueの`&mut`を取得できる
* `or_insert()`で初回の値を設定できる
  `or_insert_else()`のような遅延評価もある
