# Common Standard Traits

* `Clone`
* `Copy`
* `Default`
* `PartialEq`
* `Eq`
* `PartialOrd`
* `Ord`
* `Hash`
* `Debug`
* `Display`

## `Default`

```rust
#[derive(Default)]
enum IceCreamFlavor {
    Chocolate,
    #[default]
    Vanilla,
}
```

* `#[default]`でenumのdefaultを指定できる


```rust
#[derive(Default)]
struct Color {
    red: u8,
    green: u8,
    blue: u8,
    alpha: u8,
}

let c = Color {
    red: 128,
    ..Default::default()
};
```

* structの生成の際に便利
