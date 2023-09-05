# csv

```rust
let mut writer = csv::WriterBuilder::new()
    .terminator(csv::Terminator::CRLF)
    .flexible(false)
    .quote_style(csv::QuoteStyle::Always)
    .from_writer(writer);

// Write header
writer.write_record([/* header content ... */])?;
// Write record
writer.write_record(&["aaa","bbb"])?;

// Flush
writer.flush()?;
```

* `WriterBuilder`でcsv関連の細かい設定を行える

