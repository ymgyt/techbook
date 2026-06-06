# Segument Tree

## 実装


```rust
use std::ops::Range;

pub struct SegmentTree<T, F> {
    size: usize,
    buf: Vec<T>,
    sentry: T,
    f: F,
}

impl<T, F> SegmentTree<T, F>
where
    T: Clone + Copy,
    F: Fn(T, T) -> T,
{
    pub fn new(size: usize, init: T, f: F) -> Self {
        let size = (size as u64).next_power_of_two() as usize;
        let buf = vec![init; size * 2];

        Self {
            size,
            buf,
            sentry: init,
            f,
        }
    }

    pub fn from_vec(mut other: Vec<T>, init: T, f: F) -> Self {
        let pw2 = (other.len() as u64).next_power_of_two() as usize;
        other.resize(pw2, init);
        let mut buf = vec![init; pw2];
        buf.append(&mut other);

        for i in (1..pw2).into_iter().rev() {
            buf[i] = f(buf[i * 2], buf[i * 2 + 1]);
        }

        Self {
            size: pw2,
            buf,
            sentry: init,
            f,
        }
    }

    /// Update gienv index to new value.
    pub fn update(&mut self, index: usize, value: T) {
        let mut i = index + self.size;
        self.buf[i] = value;

        while i > 1 {
            i /= 2; // move to parent
            self.buf[i] = (self.f)(
                self.buf[i * 2],     // left child
                self.buf[i * 2 + 1], // right child
            )
        }
    }

    pub fn query(&self, range: Range<usize>) -> T {
        let mut left = range.start + self.size; // inclusive
        let mut right = range.end + self.size; // exclusive
        let mut v = self.sentry;

        while left < right {
            if left % 2 == 1 {
                v = (self.f)(v, self.buf[left]);
                left += 1;
            }
            if right % 2 == 1 {
                v = (self.f)(v, self.buf[right - 1]);
                right -= 1;
            }
            left /= 2;
            right /= 2;
        }
        v
    }

    pub fn get(&self, index: usize) -> T {
        self.buf[index + self.size]
    }
}
```



## 参考

* https://easthop.hatenablog.com/entry/2020/12/15/211044
  * Rustによる実装が参考になる
* https://zenn.dev/magurofly/articles/3aa1084dfecce2