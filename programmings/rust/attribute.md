# Attribute

## Derive

```rust
#[derive(PartialEq, Clone)]
struct Foo<T> {
    a: i32,
    b: T,
}
```

`T`をwrapした型にderiveすると、Tにboundが付与される

```rust
impl<T: PartialEq> PartialEq for Foo<T> {
    fn eq(&self, other: &Foo<T>) -> bool {
        self.a == other.a && self.b == other.b
    }
}```

## `#[deprecated]`

```rust
#[deprecated(since = "5.2.0", note = "foo was rarely used. Users should instead use bar")]
pub fn foo() {}
```

* `since`でいつからのversionを書ける
* `note`で理由やalternativesを書くのがよい
