# nom

## primitive parser

* 組み合わせのベースとなるparseの最小単位

### `tag`

```rust
use nom::bytes::complete::tag;

fn parser(s: &str) -> IResult<&str, &str> {
  tag("Hello")(s)
}

assert_eq!(parser("Hello, World!"), Ok((", World!", "Hello")));
```

* 特定の文字列やkeywordをparseする


## combinator

* create new parser by combine multiple (primitive) parser

### pair

```rust
use nom::sequence::pair;
use nom::bytes::complete::tag;

// `pair` gets an object from the first parser, then gets another object from the second parser.
let mut parser = pair(tag("abc"), tag("efg"));

assert_eq!(parser("abcefghij"), Ok(("hij", ("abc", "efg"))));
```

## use parse result

* parse結果からstructを組み立てる

```rust
use nom::combinator::map;

fn parse(input: &str) -> Result<Person,Error> {
  let mut parser = map(
    parse_person,
   |(name, old)| {
    Persion { name, old }
   },
  );

  parse(input)
}
```

* parse結果をもらって処理をかける


## 行ごとに処理する

* `nom::multi::seperated_list1`を利用する

```rust
use nom::character::complete::line_ending;

/// Parse the whole Advent of Code day 5 text file.
pub fn parse_input(s: &str) -> Vec<Line> {
    let (_remaining_input, lines) = separated_list1(line_ending, Line::parse)(s).unwrap();
    lines
}
```