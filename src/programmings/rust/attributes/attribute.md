# Attribute

## `#[repr()]`

型の内部表現についての指定をコンパイラに伝える。  
特定のアラインメントが必要、cと同じメモリレイアウト等。

### `#[repr(transparent)]`

定義しようとしている型はその内部の型と同じメモリレイアウトをもつ必要がある。  
newtype patternのようにひとつのfieldだけをもつ型で利用できる。
```rust
#[repr(transparent)]
struct UserID(String)
```

[参考](https://blog.cardina1.red/2020/12/24/defining-custom-slice-types/#defining-slice-types--repr-transparent)


## `#[must_use]`

FutureやResultのように関数の戻り値を呼び出し側が利用しなかった場合に警告をだす。

```rust
#[must_use]
fn check() -> bool { false }

// Violates
check();
```

## `[non_exhaustive]`

```rust
#[non_exhaustive]
pub struct Config {
    pub window_width: u16,
    pub window_height: u16,
}

#[non_exhaustive]
pub enum Error {
    Message(String),
    Other,
}

pub enum Message {
    #[non_exhaustive] Send { from: u32, to: u32, contents: String },
    #[non_exhaustive] Reaction(u32),
    #[non_exhaustive] Quit,
}
```

使う側
```text
// `Config`, `Error`, and `Message` are types defined in an upstream crate that have been
// annotated as `#[non_exhaustive]`.
use upstream::{Config, Error, Message};

// Cannot construct an instance of `Config`, if new fields were added in
// a new version of `upstream` then this would fail to compile, so it is
// disallowed.
let config = Config { window_width: 640, window_height: 480 };

// enumの場合はwildcardをいれることが強制される。
match error {
    Error::Message(ref s) => { },
    Error::Other => { },
    // would compile with: `_ => {},`
}
```
structに付与した場合、将来的なfieldの追加可能性を明示している。  
crate外でのconstruct処理ができなくなる。  
enumに付与した場合は、matchでwildcardを指定しておくことが強制される。

## `#[allow(clippy::name_of_lint)]`

clippyの特定のlintを許したい。

## `#[ignore]`

* test時に通常は無視されるようになる。実行するには`cargo test -- --ignored`のような指定が必要になる

## `#[path = ./test.rs]`

```rust
#[path = "../helper/mod.rs"]
pub mod helper;
```

* modの参照先を指定できる。defaultでは`./helper.rs`が参照されるが変えることできる。
  * 使い所としては、`xxx.rs`と`xxx_test.rs`のようにgoっぽくできる。
  * `tests/integration/main.rs`から`tests/helper/mod.rs`のように親のmodを参照できる

## 参考

* [Rustでプラットフォーム依存の処理を書く](https://ryochack.hatenablog.com/entry/2018/10/14/112957)

