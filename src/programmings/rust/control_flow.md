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

## `?`

`Error::from`がはいってるところがpointで、ここでuser definedな変換処理をhookしてくれている。

```rust
fn do() -> Result<(), Error> {todo!()}

// こう書くと
let v = do()?;

// こう展開される
let v = match do() {
    Ok(success) => success,
    Err(err) => return Err(Error::from(err)),
};
```
