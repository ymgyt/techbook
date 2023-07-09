# itertools

* `std::iter::Iterator`の拡張traitを提供する。
* `use itertools::Itertools`するだけ

* `join`
  * separatorで連結したStringを返してくれる

```rust
assert_eq!(["a", "b", "c"].iter().join(", "), "a, b, c")
```

## References

* [itertoolsの紹介](https://keens.github.io/blog/2019/12/06/itertoolsnoshoukai/)
  * keen先生のblog
