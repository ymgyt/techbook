# Closure

* closureがSendになるのはすべてのcaptureした値がSendの場合
* moveでcaptureしないと参照でcaptureする


## 内部的にはstruct

```rust
let amount_to_add = 3;
let add_n = |y| {
    // a closure capturing `amount_to_add`
    y + amount_to_add
};
let z = add_n(5);
assert_eq!(z, 8);
```

は

```rust
let amount_to_add = 3;
// *Rough* equivalent to a capturing closure.
struct InternalContext<'a> {
    // references to captured variables
    amount_to_add: &'a u32,
}
impl<'a> InternalContext<'a> {
    fn internal_op(&self, y: u32) -> u32 {
        // body of the lambda expression
        y + *self.amount_to_add
    }
}
let add_n = InternalContext {
    amount_to_add: &amount_to_add,
};
let z = add_n.internal_op(5);
assert_eq!(z, 8);
```

* closureでcapture(local変数を参照)するとstructのfieldになる
* 基本は`&`で参照がfieldになるが、`move`をつけるとownedになる
  * 一部の変数だけownedにしたいケースはないので、fieldではなく、closure単位で制御できるようになっている(と予想)

## Fn trait

```rust
fn<F1,F2,F3>(f1: F1, f2: F2, f3: F3) 
where
  F1: FnOnce(u64) -> u64,
  F2: FnMut(u64) -> u64,
  F3: Fn(u64) -> u64,
```

* lambdaに応じてcompilerが上記を実装してくれる
* `FnOnce`: valueをmoveした場合
* `FnMut`: `&mut`を利用
* `Fn`: `&T`を利用
