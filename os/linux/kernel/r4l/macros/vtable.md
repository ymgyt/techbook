# vtable

Cの関数pointer tableにおけるNULL abilityをrustで表現するための仕組み

Cでは未実装関数に `NULL` をいれる
```c
static const struct file_operations fops = {
  .open = my_open,
  .read_iter = NULL,
}
```

Rust では、trait implをさせたいが、実装を提供しないということが表現できない

```rust
impl FileOperations for MyDevice {
  fn open() { /*...*/ }

  // どうやって、read_iter を NULL にする？
}
```

`#[vtable]` をつけると、methodを実装したかどうかの情報が生成される

```rust
use kernel::error::VTABLE_DEFAULT_ERROR;
use kernel::prelude::*;

// Declares a `#[vtable]` trait
#[vtable]
pub trait Operations: Send + Sync + Sized {
    fn foo(&self) -> Result<()> {
        build_error!(VTABLE_DEFAULT_ERROR)
    }

    fn bar(&self) -> Result<()> {
        build_error!(VTABLE_DEFAULT_ERROR)
    }
}

struct Foo;

// Implements the `#[vtable]` trait
#[vtable]
impl Operations for Foo {
    fn foo(&self) -> Result<()> {
        // ...
    }
}

assert_eq!(<Foo as Operations>::HAS_FOO, true);
assert_eq!(<Foo as Operations>::HAS_BAR, false);
```

これにより、以下のようなbindingsが書ける

```rust
bindings::file_operations {
    read_iter: if T::HAS_READ_ITER {
        Some(Self::read_iter)
    } else {
        None
    },

    write_iter: if T::HAS_WRITE_ITER {
        Some(Self::write_iter)
    } else {
        None
    },

    ...
}
```
