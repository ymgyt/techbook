# Paragraph

* text contentをdisplayする
* wrapping, alignment, styling機能を提供する
* Span -> Line -> Text -> Paragrph

```rust
let p = Paragraph::new("Hello, World!")
    .style(Style::default().fg(Color::Yellow))
    .block(
        Block::default()
            .borders(Borders::ALL)
            .title("Title")
            .border_type(BorderType::Rounded)
    );
```

## Wrapping

```rust
let p = Paragraph::new("A very long text that might not fit the container...")
    .wrap(Wrap { trim: true });
```

* `trim: true`とするとwhite spaceをtrimしてくれる

## Alignment

```rust
let p = Paragraph::new("Centered Text")
    .alignment(Alignment::Center);
```

## Scrolling

```rust
let mut p = Paragraph::new("Lorem ipsum ...")
    .scroll((1, 0));  // Scroll down by one line
```