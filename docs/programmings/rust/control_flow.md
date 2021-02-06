# Control flow

## for

```rust
// こう書くと
for i in x {
    foo(i);
}

// こう展開される
let mut anonymous_iter = x.into_iter();
while let Some(i) = anonymous_iter.next() {
    foo(i);
}
```
