# proptest

## Usage

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::{prop_oneof, proptest, Just, Strategy};

    proptest! {
        #[test]
        #[allow(clippy::cast_possible_wrap)]
        fn apply(
            dir in direction_strategy(),
            index in 0..10_usize,
            len in 0..10_usize,
            out in index_out_of_range_strategy())
        {
            let apply = dir.apply(index, len,out) as i64;
            let index = index as i64;
            let len = len as i64;
            assert!(
                (apply - index).abs() == 1 ||
                apply == 0 ||
                apply == len-1
            );
        }


    }
    fn direction_strategy() -> impl Strategy<Value = Direction> {
        prop_oneof![
            Just(Direction::Up),
            Just(Direction::Down),
            Just(Direction::Left),
            Just(Direction::Right),
        ]
    }

    fn index_out_of_range_strategy() -> impl Strategy<Value = IndexOutOfRange> {
        prop_oneof![
            Just(IndexOutOfRange::Wrapping),
            Just(IndexOutOfRange::Saturating)
        ]
    }
}
```

### Enum 

```rust
#[derive(Debug, PartialEq, Eq, Clone, Copy)]
pub(crate) enum Direction {
    Up,
    Down,
    Left,
    Right,
}


fn direction_strategy() -> impl Strategy<Value = Direction> {
  prop_oneof![
      Just(Direction::Up),
      Just(Direction::Down),
      Just(Direction::Left),
      Just(Direction::Right),
  ]
}

proptest! {
    #[test]
    fn apply(dir in direction_strategy()) {
      // assert by dir
    }
}
```

* `prop_oneof!` macroの中で`Just`を利用する

## Config

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::{proptest, ProptestConfig};

    proptest! {
        #![proptest_config(ProptestConfig::default())]
        #[test]
        fn test_foo(n: u64) {
          
        }
    }
}
```

* test関数に`proptest_config()`で`ProptestConfig`を渡せる
