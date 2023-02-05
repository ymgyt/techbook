# `vec::Vec`

## 拡張

* 既存のsliceから拡張する
 
```rust
fn test() {
    let mut hello = Vec::new();
    hello.extend_from_slice(b"hello");
}
```

## 指定のサイズに変更する

* 指定のsizeに変更する
  * 指定されたsizeが現在のsizeより大きい場合は、第2引数で埋める
  * 指定されたsizeが現在のsizeより小さい場合は、単純に`truncate()`
* とくにかく固定長を維持したい場合に便利そう
 
```rust
fn test() {
    let mut v = vec!["a","b","c"];
    v.resize(1024,0);
}
```
