# Declarative Macro

* suffixに`!`がついているとparserがmacro展開と認識してくれる。
  * 大体直感的に使えるが、全ての場所で使えるわけではない。

## Fragment types

`$name:ident`のようにmatchする種別を指定できる

* `:ident` 変数名
  * 呼び出し側の変数に影響をあたえるためにはこれでもらう必要がある。
* `:expr` expression
* `:ty` 型名
* `:tt` token tree. なんでもマッチする。

## 繰り返し表現

`$()`これを繰り返し表現と読むとよみやすくなる。

* `$($key:expr => $value:expr),+`

## Hygiene

```rust
macro_rules! let_foo { 
  ($x:expr) => {
    let foo = $x; 
  }
}
let foo = 1;
// expands to let foo = 2; 
let_foo!(2); 
assert_eq!(foo, 1);
```

macroの中のfooのassignは外に影響をあたえない!

* 衛生的
  * 明示的に渡された変数以外には影響を与えない

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

