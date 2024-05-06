# type coercion

compilerによる暗黙の型変換

## Coercion sites

型変換が起きる場所

* `let`

```rust
let _: &i8 = &mut 42;
```

* 関数呼び出し

```rust
fn bar(_: &i8) { }

fn main() {
    bar(&mut 42);
}
```

* structのinstantiation

```rust
struct Foo<'a> { x: &'a i8 }

fn main() {
    Foo { x: &mut 42 };
}
```

* function result

```rust
use std::fmt::Display;
fn foo(x: &u32) -> &dyn Display {
    x
}
```

## Coercion types

型変換が起きる型

* `&mut T` to `&T`
* `&T` to `*const T`
* `*mut T` to `*const T`
* `&mut T` to `*mut T`
* `&T` or `&mut T` to `&U` if `T` implements `Deref<Target = U>`

```rust
use std::ops::Deref;

struct CharContainer {
    value: char,
}

impl Deref for CharContainer {
    type Target = char;

    fn deref<'a>(&'a self) -> &'a char {
        &self.value
    }
}

fn foo(arg: &char) {}

fn main() {
    let x = &mut CharContainer { value: 'y' };
    foo(x); //&mut CharContainer is coerced to &char.
}
```

* `&mut T` to `&mut U` if `T` implements `Deref<Target = U>`
* Function item to `fn` pointer
* Non capturing closure to `fn` pointer

### Unsized Coercions

よくわかってない
