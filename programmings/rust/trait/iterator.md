# iterator

一応作っておく

## `Iterator<Item=Result<T,E>>` から`Result<Vec<T>,E>`

```rust
let result: Vec<u8> = inputs
    .into_iter()
    .map(|v| <u8>::try_from(v))
    .collect::<Result<Vec<_>, _>>()?;
```

* イメージとしては、失敗しうる操作のiteratorで一つでも失敗か、成功した値のVecに変換できる
