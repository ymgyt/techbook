# RPIT

Return Position Impl Trait

```rust
fn foo() -> impl Iterator<Item=String> {
  todo!()
}
```

* 戻り値に`impl Trait`を書ける。
* 具体的な戻り値の型はcompilerが推測してくれる。
* closureを返したり、具体型を隠蔽したりできる。
* genericsが複雑で戻り値の型がわからない場合にも利用できる。
* すくなくともtraitを実装した型が存在する(exist)点をとらえて、existential types
* RPIT(Return Position Impl Trait)とも

## 2024 Edition

* scopeにある`T`, `'a`をdefaultでcaptureする
  * 2021 editionはdefualt でなにもcaptureしない
* captureしたくない場合は`use`を使う

```rust
fn process_data(
    data: &[Datum]
) -> impl Iterator<Item = ProcessedDatum> {
    data
        .iter()
        .map(|datum| datum.process())
}
```

以下のように明示的にlifetimeをboundに書かなくてよい

```rust
fn process_data<'d>(
    data: &'d '[Datum]
) -> impl Iterator<Item = ProcessedDatum> + 'd {
    data
        .iter()
        .map(|datum| datum.process())
}
```

captureさせたくない場合は

```rust

fn indices<'s, T>(
    slice: &'s [T],
) -> impl Iterator<Item = usize> + use<> {
    //                             -----
    //             Return type does not use `'s` or `T`
    0 .. slice.len()
}
```

* `-> impl Iterator<Item = usize> + 'static` 
  * `'static`をつけるとすべてのreferenceをcaptreしない挙動になる

## References

* [Changes to `impl Trait` in 2024 edition](https://blog.rust-lang.org/2024/09/05/impl-trait-capture-rules.html)
  * 2024 editionからlife timeのcaptureのdefaultが変わる
