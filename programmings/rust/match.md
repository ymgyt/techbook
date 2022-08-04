# match

```rust
enum Operation {
    A(i8),
    B(i8),
}

fn main() {
    let op = Operation::A(10);
    
    match op {
        Operation::A(n @ 10) => println!("{n}"),
        Operation::A(_) | Operation::B(_) => (),
    }
}
```
