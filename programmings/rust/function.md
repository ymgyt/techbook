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

## static変数

* ある関数からのみアクセスできるstaticな変数を定義できる。
* 値は関数を超えて保持される

```rust
fn allocate_new_id() -> u32 {
    static NEXT_ID: AtomicU32 = AtomicU32::new(0);
    NEXT_ID.fetch_add(1, Relaxed)
}
```

visibility以外は以下と同義。

```rust
static NEXT_ID: AtomicU32 = AtomicU32::new(0);

fn allocate_new_id() -> u32 {
    NEXT_ID.fetch_add(1, Relaxed)
}
```