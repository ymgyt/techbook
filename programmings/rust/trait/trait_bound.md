# trait bound

## `T: 'a'`

```rust
fn foo<'a, T: 'a'>(t: &'a T') {}

// Tには参照が含まれていることを考慮している
struct T<'b> {
  b: &'b' &str
}
```

* `T`が`'a`をout boundせよという制約。  
* `T`に参照がないか、あるとしたら`'a`をoutboundする必要がある
* これの特殊系が`T: 'static`

## Default bound

* `T: Sized`はdefaultで付与される
* `T: ?Sized`でoptoutする
  * `&T`でうけた時に`&str`を書きたい

```rust
fn size_of<T: ?Sized>(t: &T) {}
```

Tの型がわからないと基本的には困るので付与されている。

