# thread_local

## Example

```rust
thread_local! {
  static THINGS: Cell<Vec<i32>> = Cell::new(Vec::new());
}

fn f() {
  THINGS.set(vec![1, 2, 3]);

  let v: Vec<i32> = THINGS.take();

  // before
  THINGS.with(|i| i.set(vec![1, 2, 3]));
  let v = THINGS.with(|i| i.take());
}
```

* 内部的には`LocalKey<Cell<T>>`が利用される
* 1.73から、`get()`, `set()`, `take()`, `replace()`が利用できるようになった 
