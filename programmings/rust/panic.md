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


## caller(Location)

```rust
use std::panic::Location

#[track_caller]
pub fn new(future: impl Future<Output = Result<T>> + 'static) -> Task<T> {
    Task {
        future: Box::pin(future),
        created_at_file: Location::caller().file(),
        created_at_line: Location::caller().line(),
    }
}

// ...
fn main() {
  // ここのfile,lineがとれる
  let task1 = Task::new(async move { /* ... */ });
}
```

* `#[track_caller]`を付与すると、`Location::caller()` で呼び出し元のfile名と行数がわかる

内部的には

```rust

use std::panic::Location;

#[track_caller]
fn print_caller() {
    println!("called from {}", Location::caller());
}

fn main() {
    print_caller();
}
```

compilerでLocationを差し込むようなコードが生成される

```rust
use std::panic::Location;

fn print_caller(caller: &Location) {
    println!("called from {}", caller);
}

fn main() {
    print_caller(&Location::internal_constructor(file!(), line!(), column!()));
}```
