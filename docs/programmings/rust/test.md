# Test

## `cargo test`

* test時のstdoutを出力する。 `cargo test -- --nocapture`

### f64を`assert_eq`する

```rust
pub fn calc(input: f64) -> f64 {
    0.0
}

#[cfg(test)]
mod tests {
    use super::*;
    use assert_approx_eq::assert_approx_eq;

    #[test]
    fn calc_test() {
        let cases = vec![
            1.0,
            2.0,
        ];
        // 許容する誤差。
        let eps = 1e-6f64;

        for case in cases {
            assert_approx_eq!(input(case), expect, eps);
        }
    }
}
```

