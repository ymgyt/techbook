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

## `format!`

```rust
// 小数点の精度
println!("{:.1}", 0.123456); // 0.1
println!("{:.2}", 0.123456); // 0.12
println!("{:.3}", 0.123456); // 0.123
println!("{:.4}", 0.123456); // 0.1235

println!("{name} {value}", name = "ymgyt", value = 10);
```
