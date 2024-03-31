# combinator

building block parserを組み合わせる

## 複数のparserを順番に試す `alt`

```rust
use nom::branch::alt;
use nom::bytes::complete::tag;
use nom::IResult;
use std::error::Error;

fn parse_abc_or_def(input: &str) -> IResult<&str, &str> {
    alt((
        tag("abc"),
        tag("def")
    ))(input)
}

fn main() -> Result<(), Box<dyn Error>> {
    let (leftover_input, output) = parse_abc_or_def("abcWorld")?;
    assert_eq!(leftover_input, "World");
    assert_eq!(output, "abc");

    assert!(parse_abc_or_def("ghiWorld").is_err());
  Ok(())
}
```

* 上から順番にparserを試す。
* parserが`nom::Err::Failure`を返すと次を試さずにearly returnする
  * `cut`を使うことで、altのcontextでもearly returnできる


## parserを順番に適用する `sequence`

* dataは何らかの記号で囲まれていたり、区切られていたりするのでその順番を表現できる

* `delimited`: 囲まれていることを表現
* `preceded`: prefixを表現
* `terminated`: suffixを表現
* `pair`, `tuple`: 特定の順番を表現


## parse結果から値を生成

* `"true"`をparseして`true`を返したい

```rust
value(true, tag("true"))(input)

```

## 特定の条件が満たされるまでparserを適用する

* 末尾のピリオドまでparseするといったことを表現できる
* `take_until`: 引数のtagまでparse
* `take_while`: 引数のclosureがtrueの間はparse

```rust
extern crate nom;
use std::error::Error;
use nom::IResult;
use nom::bytes::complete::{tag, take_until, take_while};
use nom::character::{is_space};
use nom::sequence::{terminated};

fn parse_sentence(input: &str) -> IResult<&str, &str> {
    // "."までparseしたあと、"."とspaceをconsumeしている
    terminated(take_until("."), take_while(|c| c == '.' || c == ' '))(input)
}

fn main() -> Result<(), Box<dyn Error>> {
    let (remaining, parsed) = parse_sentence("I am Tom. I write Rust.")?;
    assert_eq!(parsed, "I am Tom");
    // I am Tomの次の"."とspaceがconsumeされている
    assert_eq!(remaining, "I write Rust.");
   
    let parsing_error = parse_sentence("Not a sentence (no period at the end)");
    assert!(parsing_error.is_err());
    Ok(())
}
```

## parserを複数回適用する `multi`

* 繰り返すのdata構造をparseする
* `count`: 指定の回数だけparserを適用
* `many`: 成功するまで適用する。結果は`Vec`
  * `many_m_n`で回数の範囲を指定できる
  * `many_til`: second parserが成功するまでfirst parserを適用
* `separated_list`: separatorを指定して、繰り返しparserを適用
* `fold_many`: `separated_list`のようにVecにせずに都度都度、fold関数を呼んでくれる

### 行ごとのparse

```rust
use nom::character::complete::line_ending;

/// Parse the whole Advent of Code day 5 text file.
pub fn parse_input(s: &str) -> Vec<Line> {
    let (_remaining_input, lines) = separated_list1(line_ending, Line::parse)(s).unwrap();
    lines
}
```
