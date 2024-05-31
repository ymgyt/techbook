# unicode_segmentation

## stringの次の境界を求める

```rust
use unicode_segmentation::GraphemeCursor;

pub struct Prompt {
    line: String,
    cursor: usize,
}

impl Prompt {
    fn insert_char(&mut self, c: char) {
        self.line.insert(self.cursor, c);
        let mut cursor = GraphemeCursor::new(self.cursor, self.line.len(), true);
        if let Ok(Some(pos)) = cursor.next_boundary(&self.line, 0) {
            self.cursor = pos;
        }
    }
}
```

## graphemeの数

```rust
use unicode_segmentation::UnicodeSegmentation;

"Hello世界".graphem(true).count();
```

## N文字以下にtrucateする

```rust
use unicode_segmentation::UnicodeSegmentation;

match s.grapheme_indices(true).map(|(i, _)| i).nth(take) {
    Some(n) => {
        s.truncate(n);
        s
    }
    None => s,
}
```

* `grapheme_indices()`でgraphemのbyte境界をiterateできる
  * 戻り値をtruncateに使って安全

* `char_indices()`でchar版の同じことができる
