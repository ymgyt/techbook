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

#### Clippy lint group

* `clippy::all`: (correctness, suspicious, style, complexity, perf) groupを含んでいる
* `clippy::correctness`: deny. プログラムの正しさに関わる
* `clippy::suspicious`: warn. あやしいコード
* `clippy`

| Category	            | Description	                                                | Default level |
| ---                   | ---                                                         | ---           |
| `clippy::all`         | all lints that are on by default                            | warn/deny     |
| `clippy::correctness` | code that is outright wrong or useless                      | deny          | 
| `clippy::suspicious`  | code that is most likely wrong or useless	                  | warn          | 
| `clippy::complexity`  | code that does something simple but in a complex way	      | warn          | 
| `clippy::perf`        | code that can be written to run faster	                    | warn          | 
| `clippy::style`       | code that should be written in a more idiomatic way	        | warn          | 
| `clippy::pedantic`    | lints which are rather strict or might have false positives	| allow         |
| `clippy::nursery`     | new lints that are still under development	                | allow         |
| `clippy::cargo`       | lints for the cargo manifest	                              | allow         |

## Attributes

* `#![deny(clippy::single_match)`
  * module(?)全体
* `#[allow(dead_code)`

## Configuration

* `clippy.toml`に書ける

```toml
disalled-names = ["foo"]
```

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
