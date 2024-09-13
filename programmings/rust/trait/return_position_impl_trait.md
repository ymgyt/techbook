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

## References

* [Changes to `impl Trait` in 2024 edition](https://blog.rust-lang.org/2024/09/05/impl-trait-capture-rules.html)
  * 2024 editionからlife timeのcaptureのdefaultが変わる
