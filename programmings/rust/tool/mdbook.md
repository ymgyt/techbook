# mdbook

## Directory構成

* `mdbook init`する
* `src`がrenderingされる対象
* `book`が結果のoutput先directory
* `src/SUMMARY.md`がmdbookが参照するfile
  * ここにlinkがあるfileだけが処理対象になる

## Command

* `mdbook build`
  * `src`からhtmlを`book`に生成する
* `mdbook serve` 
  * `book`をserveするhttp serverを起動
  * fileの変更を監視してreloadしてくれる

## Configuration

`bool.toml`に記載する

```toml
[book]
authors = ["ymgyt"]
language = "en"
multilingual = false
src = "src"
title = "techbook"

[output.html.fold]
enable = true
level = 1
```

* `output.html.fold`でsidebarの深さを指定できる

## Install

`cargo install mdbook`

