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

## `Send`と`Sync`

型`T`が別のthreadに安全に渡せるなら`Send`、`&T`が`Send`なら`T`は`Sync`。
