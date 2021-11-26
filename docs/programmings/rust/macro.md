# Macro

## Fragment types

`$name:ident`のようにmatchする種別を指定できる

* `:ident` 変数名
* `:expr` expression
* `:ty` 型名
* `:tt` token tree. なんでもマッチする。

## 繰り返し表現

`$()`これを繰り返し表現と読むとよみやすくなる。

* `$($key:expr => $value:expr),+`

## Recipe

### hashmap literal

https://stackoverflow.com/questions/27582739/how-do-i-create-a-hashmap-literal

```rust
macro_rules! hashmap {
    ($($k:expr => $v:expr),* $(,)?) => {
        std::iter::Iterator::collect(std::array::IntoIter::new([$(($k, $v),)*]))
    };
}

let h = std::collection::HashMap<_, _ > = hashmap!(
    String::from("key1") => 10,
    String::from("key2") => 20,
);
```

### test battery

```rust
macro_rules! test_battery { 
    ($($t:ty as $name:ident),*) => {
        $(
            mod $name {
                #[test]
                fn frobnified() { test_inner::<$t>(1, true) }
                #[test]
                fn unfrobnified() { test_inner::<$t>(1, false) }
            } 
        )*
    } 
}

test_battery! {
    u8 as u8_tests,
    // ...
    i128 as i128_tests
);
```

### impl trait

```rust
macro_rules! clone_from_copy { 
    ($($t:ty),*) => {
        $(impl Clone for $t {
            fn clone(&self) -> Self { *self }
        })*
    }
}
clone_from_copy![bool, f32, f64, u8, i8, /* ... */];
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
