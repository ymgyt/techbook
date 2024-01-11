 # Block

* fundamental building block for widget
* border, title情報をもつ

## Title

```rust
// Title
// Titleの位置を指定できる
let b = Block::default()
    .title(block::Title::from("Left Title").alignment(Alignment::Left))
    .title(block::Title::from("Middle Title").alignment(Alignment::Center))
    .title(block::Title::from("Right Title").alignment(Alignment::Right))
    .borders(Borders::ALL);
```

## Border style

```rust
// borderのstyleを指定できる
let b = Block::default()
    .title("Styled Header")
    .border_style(Style::default().fg(Color::Magenta))
    .border_type(BorderType::Rounded)
    .borders(Borders::ALL);
```
