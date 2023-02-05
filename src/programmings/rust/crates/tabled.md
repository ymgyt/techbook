# tabled

* table(format)な出力を行なってくれる。
* deriveの実装がmain?

## Example

```rust
use tabled::{builder::Builder, Style};

fn main() {
    let table = Builder::default()
        .set_header(["Index", "Language"])
        .add_row(["1", "English"])
        .add_row(["2", "Deutsch"])
        .build()
        .with(Style::blank());

    println!("{}", table);
}
```
