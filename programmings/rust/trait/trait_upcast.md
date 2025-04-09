# Trait Upcast

```rust
trait Trait: Supertrait {}
trait Supertrait {}

fn upcast(x: &dyn Trait) -> &dyn Supertrait {
    x
}
```

* `Arc<dyn Trait> -> Arc<dyn supertrait>`


## Any

```rust
use std::any::Any;

trait MyAny: Any {}

impl dyn MyAny {
    fn downcast_ref<T>(&self) -> Option<&T> {
        (self as &dyn Any).downcast_ref()
    }
}
```

