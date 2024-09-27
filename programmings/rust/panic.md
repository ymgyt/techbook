# panic

## unwind

* panic時の動作の一つ
* stack frame上のlocal変数を上から順にdropしていく
* special intrinsic ? `catch_unwind`に出会うまで続き

```rust
fn a(){
  let numbers = vec![0;100];
  b();
}
fn b(){
  let hello_string = "Hello World".to_string();
  c();
}
fn c(){
  let some_value = Box::new(64);
  panic!();
}
```

この場合、`some_value`がdropされ、次に`hello_string`, `numbers`がdropsされる

## catch

```rust
fn foo() {
  std::panic::catch_unwind(|| divide(a,b)) {
    Ok(x) => x,
    Err(_) => // handle panic
  }
}
```
