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

## Nesting and labels

```rust
fn main() {
    'outer: loop {
        println!("Entered the outer loop");

        'inner: loop {
            println!("Entered the inner loop");

            // This would break only the inner loop
            //break;

            // This breaks the outer loop
            break 'outer;
        }

        println!("This point will never be reached");
    }

    println!("Exited the outer loop");
}
```

* `'label: for i in 0..10'` のようにしてlabelを指定できる
* `break 'label`で参照する

## match

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

## if let

* edition 2024からscopeが変わった

```rust
// Before 2024 Edition
fn f(value: &RwLock<Option<bool>>) {
    if let Some(x) = *value.read().unwrap() {
        println!("value is {x}");
    } else {
        let mut v = value.write().unwrap();
        if v.is_none() {
            *v = Some(true);
        }
    }
    // <--- Read lock is dropped here in 2021
}

fn _f(value: &RwLock<Option<bool>>) {
    let _lock = *value.read().unwrap();
    {
        if let Some(x) = _lock {
            
        } else {
            // Dead lock happens
            value.write().unwrap();
        }
    }
```

```rust
// Starting with 2024
fn f(value: &RwLock<Option<bool>>) {
    if let Some(x) = *value.read().unwrap() {
        println!("value is {x}");
    }
    // <--- Read lock is dropped here in 2024
    else {
        let mut s = value.write().unwrap();
        if s.is_none() {
            *s = Some(true);
        }
    }
}```
