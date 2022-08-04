# clippy

* lintにはそれぞれdefaultでlint levelsが設定されている
  * そのlintに違反するとlevelに従ってwarningやerrorが出力される
  * `rustc -W help`で確認できる

* lintをsource codeで指定するかcommand lineで指定するかはpolicy次第

## Lint levelの変更

* `cargo clippy -- -A clippy::from_ver_int`のようにdefault lint levelを変更できる
  * `-A` | `--allow`: 既知だったり許可するlintを指定する
  * `-D` | `--deny` : lint違反をerrorにする


### Lint Group
 
* lint groupがありgroupでまとめて指定できる
    * lint groupには`rustc`と`clippy`の二つがある?
       * https://rust-lang.github.io/rust-clippy/master/index.html
       * https://doc.rust-lang.org/rustc/lints/listing/index.html
    * `rustc -W help`で一覧を出力できる

* `warning`がよく指定されている

## Attributes

* `#![deny(clippy::single_match)`
  * module(?)全体
* `#[allow(dead_code)`

## Recipe

```shell
cargo clippy --all-targets --all-features -- -D warning
```

* `--all-targets`でtestも対象になる
* `-D warning`はwarning lint groupの違反をエラーにする。

## Install

```shell
rustup update
rustup component add clippy
```
