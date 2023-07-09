# Function

## Function pointer

```rust
struct Foo {
    pub foo: fn(usize) -> usize,
}

impl Foo {
    fn new(foo: fn(usize) -> usize) -> Self {
        Self { foo }
    }
}

fn main() {
    let foo = Foo { foo: |a| a + 1 };
    (foo.foo)(42);
    
    (Foo::new(|a| a + 1).foo)(42);
}
```

* function pointerとclosureは別の型だが、条件を満たすとconvertされる
