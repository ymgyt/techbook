# nom

* 小さいparserを組み合わせて(combinator)で複雑なdataをparseするlib

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


## `nom::Parser`

* `FnMut(I) -> IResult<I,O,E>`にimplされているので、`use nom::Parser`しておくと以下のようにchainできるようになる
```
map( ... ).map().and_then(...)
```

## Error

```rust
use nom::error::{context, ContextError, ParseError};

fn object<'a, E: ParseError<&'a str> + ContextError<&'a str>>(
    s: &'a str,
) -> IResult<&'a str, String>, E> {

  context(
    "object",
    /* write parser... */
  )
}
```

* `fn foo(s: &str) -> IResult<&str, String>{}`とも書けるが、errorをgenericsにできる
* `context`はerrorの表示用。いまいち調べきれていない

呼び出し側

```rust
object::<VerboseError<&str>>("foo");

object::<(&str, ErrorKind)>("foo");
```
のように欲しいerrorの詳細度を呼び出し側から指定できる

### `finish()`

* `IResult<I,O,E>`は`Result<(I,O), Err<E>>`のように、`nom::Err`でwrapされており、最終的な結果としては使いづらい。`finish()`を呼ぶと、wrapをunwrapしてくれるイメージ。

