# BinaryHeap

* push したitemの中からもっとも`cmp::Greater` なものをpop してくれる
  * priority queueとも

```rust
use std::collections::BinaryHeap;

#[derive(Eq, PartialEq)]
struct Item {
    org_price: usize,
    price: usize,
    count: usize,
}

impl PartialOrd for Item {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

// やすいItemを優先したいので、Greaterを返すようにしている
impl Ord for Item {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        other.price.cmp(&self.price)
    }
}

fn main() {
    let mut heap = BinaryHeap::new();
    for _ in 0..n {
        let price = s.scan::<usize>();
        heap.push(Item {
            price,
            org_price: price,
            count: 1,
        });
    }

    let mut buy = 0;
    let mut m = m;
    loop {
        let Item {
            price,
            count,
            org_price,
        } = heap.pop().unwrap();
    }
}
```
