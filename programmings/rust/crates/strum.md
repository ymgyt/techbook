# strum

## FromStrを生やす

```rust
use std::str::FromStr;
use strum_macros::EnumString;

#[derive(Debug, PartialEq, EnumString)]
enum Color {
    Red,
    // The Default value will be inserted into range if we match "Green".
    Green {
        range: usize,
    },
    // We can match on multiple different patterns.
    #[strum(serialize = "blue", serialize = "b")]
    Blue(usize),

    // Notice that we can disable certain variants from being found
    #[strum(disabled)]
    Yellow,

    // We can make the comparison case insensitive (however Unicode is not supported at the moment)
    #[strum(ascii_case_insensitive)]
    Black,
 }
```

生成されるコード

```rust
//The generated code will look like:
impl std::str::FromStr for Color {
    type Err = ::strum::ParseError;
    fn from_str(s: &str) -> ::core::result::Result<Color, Self::Err> {
        match s {
            "Red" => ::core::result::Result::Ok(Color::Red),
            "Green" => ::core::result::Result::Ok(Color::Green { range:Default::default() }),
            "blue" => ::core::result::Result::Ok(Color::Blue(Default::default())),
            "b" => ::core::result::Result::Ok(Color::Blue(Default::default())),
            s if s.eq_ignore_ascii_case("Black") => ::core::result::Result::Ok(Color::Black),
            _ => ::core::result::Result::Err(::strum::ParseError::VariantNotFound),
        }
    }
}
```
