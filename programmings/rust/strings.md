# Strings

## Raw string

string literals

```rust
let s = r#"
  hello
"#;
```


## char

### char <-> 数字

```rust

'3'.to_digit(10);
char::from_digit(5, 10);
```

`to_digit()`, `from_digit()`で変換できる。基数も指定できる。