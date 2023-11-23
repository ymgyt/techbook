# SpinLock

RAaL本にのっていた、SpinLockの実装。
Send,Syncの制約付与が適当というか、わかっていない。

```rust
use std::{
    cell::UnsafeCell,
    ops::{Deref, DerefMut},
    sync::atomic::{AtomicBool, Ordering::*},
    thread,
};

struct SpinLock<T> {
    value: UnsafeCell<T>,
    locked: AtomicBool,
}

struct Guard<'a, T> {
    lock: &'a SpinLock<T>,
}

impl<'a, T> Deref for Guard<'a, T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        // Guard自体が排他accessを表現している
        unsafe { &*self.lock.value.get() }
    }
}

impl<'a, T> DerefMut for Guard<'a, T> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        unsafe { &mut *self.lock.value.get() }
    }
}

impl<'a, T> Drop for Guard<'a, T> {
    fn drop(&mut self) {
        self.lock.locked.store(false, Release)
    }
}

// RAaL本だとwhere句ある
unsafe impl<T> Sync for SpinLock<T> {}

impl<T> SpinLock<T> {
    fn new(value: T) -> Self {
        Self {
            value: UnsafeCell::new(value),
            locked: AtomicBool::new(false),
        }
    }

    fn lock<'a>(&'a self) -> Guard<'a, T> {
        while self
            .locked
            .compare_exchange(false, true, Acquire, Relaxed)
            .is_err()
        {
            std::hint::spin_loop()
        }
        Guard { lock: self }
    }
}

fn main() {
    let x = SpinLock::new(Vec::new());
    thread::scope(|s| {
        s.spawn(|| x.lock().push(1));
        s.spawn(|| {
            let mut g = x.lock();
            g.push(2);
            g.push(2);
        });
    });
    let g = x.lock();
    assert!(g.as_slice() == [1, 2, 2] || g.as_slice() == [2, 2, 1]);
}
```