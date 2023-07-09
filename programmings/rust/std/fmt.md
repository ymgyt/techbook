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
