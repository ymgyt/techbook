# Drop Check

```rust
struct Foo<'a>(&'a mut bool);

fn main() {
    let mut x = true;
    let foo = Foo(&mut x);

    x = false;
}

// Dropが実装されているとcompileが通らない!
// Dropの実装をコメントアウトすると↑はcompileが通る
impl Drop for Foo<'_> {
    fn drop(&mut self) {}
}
```
