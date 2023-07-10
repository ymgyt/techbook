# Calc

## 組み合わせの数

いわゆるfrom個からchice個選ぶ場合の組み合わの数

```rust
/// これは遅い。
/// 30C3で300μsくらい
pub fn count_combinations_iter(from: usize, choice: usize) -> usize {
    use itertools::Itertools;
    (0..from).combinations(choice).count()
}

/// 30C3で30nsくらいなので、1000倍以上速い
pub fn count_combinations(from: usize, choice: usize) -> usize {
    let (n, r) = (from, choice);
    if r > n {
        0
    } else {
        (1..=r).fold(1, |acc, val| acc * (n - val + 1) / val)
    }
}
```

