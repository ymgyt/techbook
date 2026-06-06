# dotenv

## Example

```rust
use dotenv::dotenv;
use std::env;

fn main() {
    dotenv().ok();

    for (key, value) in env::vars() {
        println!("{}: {}", key, value);
    }
}
```

* `.env`というfileをrootまで探して見つけたら環境変数としてセットする
