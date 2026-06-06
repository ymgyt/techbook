# `fmt`

## format 

```rust
fn example() {
    let person = get_person();
    // ...
    println!("Hello, {person}!"); // captures the local `person`
}
```
* `#`: 代替指定(普段は省かれる情報を追加する)
  * `{:#?}` pretty print
  * 数値の場合、`{:#X}` 0埋めで、0xのようなprefixをつける

```rust
fn example() {
    let (width, precision) = get_format();
    for (name, score) in get_scores() {
        println!("{name}: {score:width$.precision$}");
    } 
}
```

### padding

```rust
let ans = 100;
println!("{ans:0>10"});
```

* `: <padding_char> <align_spec> <width>`という指定
  * 0埋め、 `>` contentは右詰め, `10`幅は10という指定になる

#### width

最低の幅を指定できる

```rust
// 全て同じ指定
println!("{:width$}", width = 10);
println!("{:10$}");
```

* `<width_var>$` suffixで`$`を付与すると、幅の指定を変数に切り出せる
