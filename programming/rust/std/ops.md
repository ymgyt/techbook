# `std::ops`

## `Range`

`0..3`で作られる型。  

```rust
pub struct Range<Idx> {
    pub start: Idx,
    pub end: Idx,
}

assert_eq!((3..5), std::ops::Range { start: 3, end: 5 });
```



### `RangeBounds`

`0..n`, `0..=n`, `3..`のような様々なrangeをうけたい場合のtrait

```rust
use std::ops::{Bound, RangeBounds};
pub fn range_decide<R: RangeBounds<usize>>(range: R, len: usize) -> (usize, usize) {
    let start = match range.start_bound() {
        Bound::Unbounded => 0,
        Bound::Excluded(&s) => s + 1,
        Bound::Included(&s) => s,
    };
    let end = match range.end_bound() {
        Bound::Unbounded => len,
        Bound::Excluded(&t) => t.min(len),
        Bound::Included(&t) => (t + 1).min(len),
    };
    assert!(start <= end);
    (start, end)
}
```

要はstart,endにどのような制約(inclusive,exclusive,指定なし)があるかをenumで返してくれる


## `Index`

* `container[0]`のような添字accessを定義できる

```rust

pub struct ShortestPaths(Vec<Vec<i64>>);

impl Index<usize> for ShortestPaths {
    type Output = [i64];

    fn index(&self, index: usize) -> &Self::Output {
        self.0[index].as_slice()
    }
}
```
