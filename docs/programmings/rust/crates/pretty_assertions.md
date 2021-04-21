# pretty_assertions

test時の`assert_eq!()`のdiffを見やすく表示したい。

Cargo.toml
```toml
[dev-dependencies]
pretty_assertions = "*"
```

test
```rust
#[cfg(test)]
mod tests {
    use pretty_assertions::{assert_eq};

    #[test]
    fn test() {
        assert_eq!("AAA","BBB");
    }
}
```
