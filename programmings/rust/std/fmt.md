# `fmt`

## format 

```rust
fn example() {
    let person = get_person();
    // ...
    println!("Hello, {person}!"); // captures the local `person`
}
```

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
