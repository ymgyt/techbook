# nom recipe

## Semver

```rust
use nom::{
    AsChar, IResult, Parser as _,
    bytes::complete::take_while1,
    character::complete::{char, digit1},
    combinator::{map_res, opt, recognize},
};
use semver::Version;

pub(crate) fn semver(input: &str) -> IResult<&str, Version> {
    map_res(
        recognize((
            digit1,
            char('.'),
            digit1,
            char('.'),
            digit1,
            // pre-release
            opt((char('-'), take_while1(is_identifier))),
            // build
            opt((char('+'), take_while1(is_identifier))),
        )),
        |s: &str| Version::parse(s),
    )
    .parse(input)
}

fn is_identifier(c: char) -> bool {
    c.is_alphanum() || c == '.' || c == '-'
}
```
