# building block parser

combinatorの土台となるparser集

## 文字列

* `space0`,`space1`: 複数のspace,tabをparse
* `line_ending`: `\n`と`\r\n`をparse
* `alpha0`,`alphanumeri0`,`digit`: 文字、数字をparse

### 特定の文字列をparseする `tag`

```rust
use nom::bytes::complete::tag;

fn parser(s: &str) -> IResult<&str, &str> {
  tag("Hello")(s)
}

assert_eq!(parser("Hello, World!"), Ok((", World!", "Hello")));
```

* 特定の文字列やkeywordをparseする
