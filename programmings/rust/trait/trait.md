# Trait

* `Self`はそのtraitを実装している型のalias

## `Deref`

* Rustは継承という概念をもっていないが、`Deref`を使って、同様の機能を実現している。  
* `T: Deref<Target = U>`ならUに実装されているmethodを直接Tの値をreceiverとして呼ぶことができる。


## `Sized`

その型のメモリ上のsizeがcompile時にわかっていることを要求するtrait。  
trait objectとslice以外には基本的には自動的にimplされている。

基本的にRustでは型にSizedが要求される。
* local変数はSized(stack frameの割当計算できないから)
* 関数の引数/戻り値はSized
* Struct FieldはSized

*Generic Type parameters are sized by default*  
`T: Sized`が暗黙的に要求されている。  
なので、TにSizedを要求しない場合は明示的にopt outしてやる必要がある  
`T: ?Sized` (?はmay not be)

`&str`を引数にとれるGenericsを書きたければ
```rust
fn f<T: ?Sized>(x: &T) { }
```
`str`はunsized。

ただし、traitの暗黙的type parameterのSelfについては、デフォルトのSizedが適用されていない。  
なので、traitの宣言では、Sizedを要求する場合明示する必要がある

```rust
trait A: Sized { ... }

trait WithConstructor {
    fn new_with_param(param: usize) -> Self;

    fn new() -> Self
        where
            Self: Sized,
    {
        Self::new_with_param(0)
    }
}
```

## Orphan Rule

you can implement a trait for a type only if the trait or the type is local to your crate.  

* `Debug`を自前の型に書ける
* `MyTrait`をboolに実装できる
* `Debug`をboolに実装できない

## Marker Traits

* methodをもたない
* ある型がある方法で使える/使えないを示すためにある
  * Sendがthreadまたげるとか

## Higher-ranked trait bound

まったく謎の概念。  
Rustforrustacieansのコードを一応載せておく。

```rust
use std::fmt::Debug;

impl Debug for AnyIterable
where
    for<'a> &'a Self: IntoIterator,
    for<'a> <&'a Self as IntoIterator>::Item: Debug,
{
    fn fmt(&self, f: &mut Formatter) -> Result<(), Error> {
        f.debug_list().entries(self).finish()
    }
}
```

## Blanket Implementation

ある型Tにtraitを実装した場合でも、&Tにそのtraitは自動的に実装されない。
traitが`&self`しかとらない場合、`&T`にそのtraitが実装されていることをユーザは期待する。

そこで可能なら以下のblanket implementationを提供しておくとよい
* `&T where T: Trait`
* `&mut T where T: Trait`
* `Box<T> where T: Trait`


## RPITIT

Return Position Impl Trait In Traits

```rust
trait Container {
    fn items(&self) -> impl Iterator<Item = Widget>;
}

impl Container for MyContainer {
    fn items(&self) -> impl Iterator<Item = Widget> {
        self.items.iter().cloned()
    }
}
```

* traitのretunrに`impl Trait`を書けるようになった
  * [公式Blog](https://blog.rust-lang.org/2023/12/21/async-fn-rpit-in-traits.html)

* これによって`async fn`もかけるようになった
  * `return impl Future`のsugarなので

```rust
trait HttpService {
    async fn fetch(&self, url: Url) -> HtmlBody;
//  ^^^^^^^^ desugars to:
//  fn fetch(&self, url: Url) -> impl Future<Output = HtmlBody>;
}
```

## Sealed

traitをpublicにしつつ、downstreamにimplさせたくない

```rust
pub trait MyTrait: private::Sealed {
    fn foo();
}

impl MyTrait for usize {
    fn foo() { /* ... */ }
}

mod private {
    pub trait Sealed {}

    impl Sealed for usize {}
}
```

* `MyTrait`をimplしたくても、`private` modがみえないので、implできない
