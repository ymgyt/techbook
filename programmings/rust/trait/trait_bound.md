# trait bound

## `T: 'static`

Tはownedか`&'static`なfieldだけをもつことを要求。  
threadまたぐ際に要求されがち。threadまたぐと、元threadのcallstackの存在を仮定できなくなるから。

## `T: 'a'`

`T: 'a` is saying is that any references in T must outlive 'a.

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


## Example

```rust
pub fn dump_sorted<T>(mut collection: T)
where
    T: Sort + IntoIterator,
    T::Item: std::fmt::Debug,
{
    // Next line requires `T: Sort` trait bound.
    collection.sort();
    // Next line requires `T: IntoIterator` trait bound.
    for item in collection {
        // Next line requires `T::Item : Debug` trait bound
        println!("{:?}", item);
    }
}
```

* `T::Item`でtraitのassociate typeにもboundを書ける
