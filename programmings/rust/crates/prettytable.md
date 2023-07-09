# prettytables

* consoleへの出力をtableの形に整形してくれる
* `cargo add prettytable-rs`

```rust
use prettytable::{format, row, Table};

fn print_validations(mut writer: impl Write, items: impl IntoIterator<Item = Item>) -> Result<(), Error> {
    let mut table = Table::new();
    let format = format::FormatBuilder::new().column_separator(' ').build();

    table.set_format(format);
    table.set_titles(row!["A", "B", "C"]);

    for v in items {
        table.add_row(row![
            v.a,
            v.b,
            v.c
        ]);
    }

    table
        .print(&mut writer)?;

    Ok(())
}
```
