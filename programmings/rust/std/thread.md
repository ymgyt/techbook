# `std::thread`

* すべてのprogramはmain threadという1つのthreadからはじまる

## `spawn`

* 引数はthreadが実行する関数
* 引数の関数がreturnするとthreadは停止する
  * 引数はSendである必要がある
* `std::thread::Builder::new().spawn()`が内部的に実行されている
  * Builderを用いると、名前はstack sizeを設定できる
  * spawn()の失敗をResultでhandlingできる(thread::spawn()はpanic)

## `ThreadId`

* `std::thread::current().id()`で取得できる
* threadの識別子。連続している保証はない。(なんならu64の保証もない)

## `Result`

`std::thread::Result<T>`は以下のように定義されている。
```rust
pub type Result<T> = Result<T, Box<dyn Any + Send + 'static>>;
```

* `dyn Any`なので、`Result::Err` variantにおいて、情報としてはなにも保証されていない
* `panic!()` マクロの引数が渡されるので`Any`になっている。

## Scoped thread

```rust
use std::thread;

fn main() {
    let numbers = vec![1, 2, 3];

    thread::scope(|s| {
        s.spawn(|| {
            println!("Len: {}", numbers.len());
        });
        s.spawn(|| {
            for n in &numbers {
                println!("{n}");
            }
        });
    });

    // ここで、spawnされたthreadが終了(join)されることが保証されている
}
```

threadをspawnする際、spawn元のthreadよりもspawnされたthreadが長く生きる可能性があるので、move以外でclosureとしてlocal変数を参照(捕捉)できない。  
そこで、scoped threadを利用すると、threadの終了を制御できる。  
上の例では、`thread::scope()`が終了するとscopeがspawnしたthreadもjoinされるので、local変数を参照できる
