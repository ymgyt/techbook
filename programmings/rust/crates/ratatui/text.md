# Render Text

* Span -> Line -> Textという粒度
* 最終的にTextで文字列を表示する
* TextとParagraphの関係は
  * Textはdata構造で、Paragraphはwidget?

## Span

textのstylingされたsegment

```rust
let span = Span::raw("This is text that is not styled");

let span = Span::styled("This is text that will be yellow", Style::default().fg(Color::Yellow));

// Stylize trait
let span = "This is text that will be yellow".yellow();
```

## Line

`Vec<Span>`

```rust
// Vec<Span>から作成
let line = Line::from(vec![ "hello".red(), "world".red().bold() ]);

// Into<Cow<'a, str>>'から作成
let line = Line::from("hello world");

// direct
let line = Line::styled("hello", Style::default());

// Stylize
let line: Line = "hello".yello().into();
```

## Text

```rust
// Vec<Line>から生成
Text::from(vec![Line::from("")])
```