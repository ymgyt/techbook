# Declarative Macro

* suffixに`!`がついているとparserがmacro展開と認識してくれる。
  * 大体直感的に使えるが、全ての場所で使えるわけではない。

## Fragment types

`$name:ident`のようにmatchする種別を指定できる

* `:ident` 変数名
  * 呼び出し側の変数に影響をあたえるためにはこれでもらう必要がある。
  * keywordにもmatchする(`fn foo`はident identでmatch)
* `:expr` expression
* `:ty` 型名
* `:tt` token tree. なんでもマッチする。
  * `{ ... }`のようにカッコでくくった場合にマッチする
* `:literal`
  * `-1`, `"hello"`, `true`のようなliteralにマッチする

## 繰り返し表現

* `$(...)sep rep`の形で繰り返しのpatternを表現する
  * `$(...)`の表現がsepで区切られることを表現している

* `$($key:expr => $value:expr),+`

* 繰り返しはnestさせることができる
* 利用する場合も同様に`$()*`を使う
    * 利用側でもnestさせるとnestに応じた変数が見えるようになる
    * 利用時にも繰り返し表現を何でseparateするか指定できる
    * `$(x:expr),*`で受けて`$( v.push($x) )*`のようにseparatorをしないことも可能
    * patternとexpansionでseparatorは一致している必要はない

```rust
macro_rules! foo {
    ( $( { $($key:expr => $value:expr),* }),* ) => {
        $(
            $(
                println!("{}:{}",$key, $value);
            )*
        )*
    }
}

fn main() {
    foo!({"a1" => "b", "a2" => "b"}, {"c1" => "d"});
}
```

###`$($x:expr),*`と`$($x:expr,)*`の違い

* separatorが繰り返し表現の一部かどうかが違う
* 後者は末尾にカンマが必須になる
  * `foo!("a","b",)`

### trailingカンマの両対応

* `foo!(1,2)`と`foo!(1,2,)`のように末尾のカンマがあってもなくてもよいようにしたい
* `$( $x:expr ),* $(,)?`とする
  * `,`で区切りつつ最後に任意の一つのカンマを許容する
 
## Publish macro

* `macro_rules!`で定義したmacroを公開するには

### Within same crate

```rust
foo::bar!();  // works

mod foo {
    macro_rules! bar {
        () => ()
    }

    pub(crate) use bar;    // <-- the trick
}

foo::bar!();  // works
```

* `pub use bar`でre-exportする
  * 定義の前後にかかわらず参照できる
  * crate内にとどめたければ`pub(crate) use bar`

### Across crates

```rust
#[macro_export]
macro_rules! foo {
    () => ()
}
```

* `#[macro_export]`をつける

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

### macro呼び出し側にmacro側で定義した変数を参照させたい

```rust
macro_rules! setup {
    ( $scanner:ident ) => {
        let _stdin = std::io::stdin();
        let mut $scanner = cio::Scanner::from(&stdin);
    };
}

setup!(s);

s.foo();
```

* macro側は`$xxx:ident`で呼び出し側から変数名を`ident`でもらう必要がある
  * 呼び出し側はmacro側で使う変数を渡す

## Debug

macroのdebugの仕方。

1. nightlyを使う
2. `#![feature(trace_macros)]`を有効にする
3. `trace_macros!(true)`で有効にする

```rust
#![feature(trace_macros)]
fn main() {
    trace_macros!(true);
    println!("hello");
    trace_macros!(false);
}
```

`cargo +nightly run`

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

### define environment variable key

```rust
macro_rules! def_env {
        ( $key:expr ) => {
            concat!("APP_", $key)
        };
    }

/// Specify application logging directive.
/// like "LOG=app=debug,info".
pub static LOG_DIRECTIVE: &str = def_env!("LOG");
```

### Counting

```rust
macro_rules! replace_expr {
    ($_t:tt $sub:expr) => {$sub};
}

macro_rules! count_tts {
    ($($tts:tt)*) => {<[()]>::len(&[$(replace_expr!($tts ())),*])};
}
```
