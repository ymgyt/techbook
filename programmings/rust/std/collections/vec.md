# `vec::Vec`

## 拡張

* `extend_from_slice()`
  * 既存のsliceから拡張する
 
```rust
fn test() {
    let mut hello = Vec::new();
    hello.extend_from_slice(b"hello");
}
```

* `append()`
  * 既存のvecから拡張する
  * 引数のvecは空になる

```rust
fn test() {
    let mut vec = vec![1, 2, 3];
    let mut vec2 = vec![4, 5, 6];
    vec.append(&mut vec2);
    assert_eq!(vec, [1, 2, 3, 4, 5, 6]);
    assert_eq!(vec2, []);    
}
```


## 指定のサイズに変更する

* `resize()`
  * 指定のsizeに変更する
  * 指定されたsizeが現在のsizeより大きい場合は、第2引数で埋める
  * 指定されたsizeが現在のsizeより小さい場合は、単純に`truncate()`
 
```rust
fn test() {
    let mut v = vec!["a","b","c"];
    v.resize(1024,0);
}
```

## Uniqueにする

```rust
fn test() {
  let mut buf = vec![1,2,1];
  buf.sort_unstable();
  buf.dedup();
}
```

* sortとdedupの合せ技でuniqueにできる

## Sliceにする

```rust
let v = vec![1,2,3];
let s = &v[1..2];
```

内部的には`v[ ]`がindexing expressionになって、`*v.index(Range)`になるらしいがよくわかってない

## Sort

```rust
use std::cmp::Reverse;

let mut v = vec![3,5,2,7];
v.sort_unstable_by_key(|x| Reverse(*x));
```
