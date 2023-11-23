# Box

## `leak()`

```rust
  let x: &'static [i32; 3] = Box::leak(Box::new([1, 2, 3]));
```

* Boxからstatic 参照を取得できる。
  * 解放されないのでprogram終了までメモリは確保し続けられる