# const

## const context

```rust
static VERSION: u64 = 130;
const PAGE_SIZE: usize = 4096;
```

* `static`/`const`の変数の右辺はconst contextとして評価され、特有の制約がある
  * 関数呼び出しができない


## `const fn`

```rust
const fn foo(n: i64) -> i64 { n + 1 }
```

* const contextで呼び出せる関数
* bodyで利用できるexpressionに制限がある
* 一種の契約なのでなんでもconstにできるものはconstにすればよいわけではない。

### 関数内でできること

* `const fn`の呼び出し
* `while` loop
* structの作成
