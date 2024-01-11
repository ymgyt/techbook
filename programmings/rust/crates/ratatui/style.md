# Style

以下のstyleに関する情報を保持

* `fg(Color)`
* `bg(Color)`
* modifier
  * BOLD
  * DIM
  * ...


## Color

```rust
use std::str::FromStr;

let color: Color = Color::from_str("blue").unwrap();
assert_eq!(color, Color::Blue);

let color: Color = Color::from_str("#FF0000").unwrap();
assert_eq!(color, Color::Rgb(255, 0, 0));

let color: Color = Color::from_str("10").unwrap();
assert_eq!(color, Color::Indexed(10));
```