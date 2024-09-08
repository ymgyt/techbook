# mockall

1. mockしたいtraitにannotateする

```rust
#[cfg_attr(test, mockall::automock)]
trait SubscribeFeed {
    async fn subscribe_feed(&self, input: SubscribeFeedInput) -> Result<types::Feed, SyndApiError>;
}
```

2. mock objectを生成して、期待値をencodeする

```rust
// Mock prefixが付与される
let mut mock = MockSubscribeFeed::new();

// 期待値のencode
mock.expect_subsribe_feed()
    .returing(|_input| Ok(/* ...*/ _));

do_test(mock);
```


## 戻り値

mockの呼び出し側に返す値の指定。  
`_st` はsingle thread版の略で、戻り値の型にSendを要求しない

```rust
mock.expect_foo()
    .returing(|arg| arg + 1)
```

* `returing`: closure(FnMut)を渡す、引数はmockのmethodの引数(by value)
  * 何回でも呼べる
  * `returing_st`: single thread版. 戻り値の型にSendを要求しない

* `return_once`: closure(FnOnce)を渡す。複数回よばれるとpanic
* `return_const`: Cloneな戻り値を返せる

## 引数のassertion

引数に対する期待のencode

```rust
mock.expect_foo()
    .withf(|input| input == "foo" )
```

* `predicate` moduleでgenericになっているらしいが使いこなせていない
* `withf`でclosure渡せるのでこれでよいのでは

## 回数の指定

defaultでは何回でも呼び出せる

```rust
mock.expect_foo()
    .times(1)
```

## 呼び出し順序の指定

defaultでは、呼び出す順番に制限がない

```rust
let mut seq = Sequence::new();

mock.expect_foo()
    .times(1)
    .in_sequence(&mut seq)

mock.expect_foo()
    .times(1)
    .in_sequence(&mut seq)
```

* `in_sequence`に`Sequence`を渡して順序を指定できる


