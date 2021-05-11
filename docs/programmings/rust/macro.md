# Macro

## Recipe

### hashmap literal

https://stackoverflow.com/questions/27582739/how-do-i-create-a-hashmap-literal

```rust
macro_rules! hashmap {
    ($($k:expr => $v:expr),* $(,)?) => {
        std::iter::Iterator::collect(std::array::IntoIter::new([$(($k, $v),)*]))
    };
}

let h = std::collection::HashMap<_,_> = hashmap!(
    String::from("key1") => 10,
    String::from("key2") => 20,
);
```
