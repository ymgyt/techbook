# Trait

## `Borrow<T>`と`AsRef<T>`

```rust
pub trait Borrow<Borrowed> 
where
    Borrowed: ?Sized, 
{
    pub fn borrow(&self) -> &Borrowedⓘ;
}
```

```rust
pub trait AsRef<T> 
where
    T: ?Sized, 
{
    pub fn as_ref(&self) -> &Tⓘ;
}
```

共通点は両者とも`T`への参照を提供をできる。 

`Borrow<T>`のほうが`AsRef<T>`より制約が強い。  
例えば、`impl Borrow<T> for K`の場合、`T`と`K`は`Eq`は`Hash`で整合性があるようにしなければならない。  
具体的には、`x == y` => `x.borrow() == y.borrow()`, `x != y` => `x.borrow() != y.borrow()`を守る。
