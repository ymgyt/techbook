# marker

## `PhantomPinned`

* `!Unpin`(Unpinをopt out)したいときに使う

```rust
use std::marker::PhantomPinned;

struct SelfRef {
    x: u32,
    ptr: *const u32,
    _pinned: PhantomPinned,
}
```

これで`SelfRef`は`!Unpin`になる。
