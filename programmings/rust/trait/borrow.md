# Borrow

## `Borrow<T>`と`AsRef<T>`

```rust
pub trait Borrow<Borrowed> 
where
    Borrowed: ?Sized, 
{
    pub fn borrow(&self) -> &Borrowed;
}
```

```rust
pub trait AsRef<T> 
where
    T: ?Sized, 
{
    pub fn as_ref(&self) -> &T;
}
```

共通点は両者とも`T`への参照を提供をできる。 


`Borrow<T>`のほうが`AsRef<T>`より制約が強い。  
例えば、`impl Borrow<T> for K`の場合、`T`と`K`は`Eq`は`Hash`で整合性があるようにしなければならない。  
具体的には、`x == y` => `x.borrow() == y.borrow()`, `x != y` => `x.borrow() != y.borrow()`を守る。

## `T`と`&T`の抽象化

`impl<T> Borrow<T> for T`のgeneric implが`Borrow`にある。  
これは、`Borrow`で`T`と`&T`を抽象化できることを示唆している

```rust
fn add_four<T: Borrow<i32>>(v: T) -> i32 {
  v.borrow() + 4
}

add_four(&2)
add_four(2)
```

## `ToOwned`

`x.to_owned()`の変換先の型は変換元をBorrowできる制約が付与されている。(ざっくり、Borrowの逆)

```rust
pub trait ToOwned {
    type Owned: Borrow<Self>;

    fn to_owned(&self) -> Self::Owned;

    fn clone_into(&self, target: &mut Self::Owned) { ... }
}
```
