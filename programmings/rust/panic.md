# panic

## unwind

* panic時の動作の一つ
* stack frame上のlocal変数を上から順にdropしていく

## catch

```rust
fn foo() {
  std::panic::catch_unwind(|| divide(a,b)) {
    Ok(x) => x,
    Err(_) => // handle panic
  }
}
```
