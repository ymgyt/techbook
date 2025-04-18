# itertools

* `std::iter::Iterator`の拡張traitを提供する。
* `use itertools::Itertools`するだけ

* `join`
  * separatorで連結したStringを返してくれる

```rust
assert_eq!(["a", "b", "c"].iter().join(", "), "a, b, c")
```

## 値からiteratorを生成する unfold

```rust
use itertools::unfold;

let mut fibonacci = unfold((1u32, 1u32), |(x1, x2)| {
    // Attempt to get the next Fibonacci number
    let next = x1.saturating_add(*x2);
    // Shift left: ret <- x1 <- x2 <- next
    let ret = *x1;
    *x1 = *x2;
    *x2 = next;
    // If addition has saturated at the maximum, we are finished
    if ret == *x1 && ret > 1 {
        None
    } else {
        Some(ret)
    }
});

itertools::assert_equal(fibonacci.by_ref().take(8),
                        vec![1, 1, 2, 3, 5, 8, 13, 21]);
```

* foldはitertorを処理して最終的な値を生成する。unfoldは逆で、値(状態)からitertorを作る
* closureの返り値は生成するiteratorのyield値, 状態は`&mut`で渡されるのでclosure内で更新して状態を進める前提

## separatorを間に入れる

```rust
itertools::assert_equal(intersperse((0..3), 8), vec![0, 8, 1, 8, 2]);
```

* iteratorにseparatorとして特定の間を差し込みたいときにつかえる
* joinの汎用版?

## Permutation(順列)

```rust

use itertools::Itertools;

let perms = (5..8).permutations(2);
itertools::assert_equal(perms, vec![
    vec![5, 6],
    vec![5, 7],
    vec![6, 5],
    vec![6, 7],
    vec![7, 5],
    vec![7, 6],
]);

// nの順列
let n = 6;
let n_perm = (0..n).permutations(n);
for p in n_perm {
  println!("{p:?}");
  // [0, 1, 2, 3, 4, 5]
  // [0, 1, 2, 3, 5, 4]
  // [0, 1, 2, 4, 3, 5]
  // [0, 1, 2, 4, 5, 3]
  // ...
}
```

* 値のrangeと要素の数を指定する

## References

* [itertoolsの紹介](https://keens.github.io/blog/2019/12/06/itertoolsnoshoukai/)
  * keen先生のblog
