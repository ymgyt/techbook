# zola

## Install

```shell
git clone https://github.com/getzola/zola.git
cd zola
cargo install --path .
```

## Usage

```shell
# init directory
zola init

# build and output to public directory
zola build [--base-url] [--output-dir] [--config] [--root]

# serve html
zola serve [--port <port>] [--interface 0.0.0.0] [--base-url /] [--open]

# check
zola check [--draft]
```

## Directory structure

```text
.
├── config.toml
├── content
├── sass
├── static
├── templates
└── themes
```

* `config.toml`: zolaのconfig
* `content`: markup fileの格納場所。subdirectoryはsectionを表す
* `sass`: compileされるsass fileの格納場所。
  * sass file以外は無視される
  * `sass/something/site.scss`は`public/somehting/site.css`に対応する
* `static` static fileの格納場所。
  * `public`にfile/directoryそのままcopyされる
    * `hard_link_stattic = true`にするcopyされなくなる
* `template`: tera templateの格納場所
* `themes`: themeの格納場所。使わないなら空。

## asset fileの参照方法

記事にimageを設置したい場合3つの選択肢がある。  
`entry`pageを例にする

1. `content/entry/entry_1/image.png`
  * page用のdirectoryをきって、そこに画像をおく
  * `./image.png`で参照する

1. `static/entry/entry_1/image.png`
  * static directoryにおく。
  * `./image.png`で参照する
  * 近くに(co-located)に置くか、staticに置くかはpolicy次第

1. `static/image`のような任意のdirectoryを切ってそこにおく
  * `images/image.png`で参照する
  * 色々なpageから参照される共通のassetはこれがよい

## Content

### Section

* `content` dir配下で`_index.md`を含むdirectoryがsectionになる
  * `_index.md`含まなくてもmd fileはpageを生成する
  * `content/_index.md`は`templates/index.html`から参照できる

```toml
+++
title = "Blog entries"
sort_by = "date"
template = "entry.html"
page_template = "entry_page.html"
+++
```

* `sort_by`: pageを何でsortするか。page側で定義される`date`を参照できる
* `template`: sectionで参照するtemplate
* `page_templaet`: section配下のpageでdefaultで利用するtemplate. page側でoverrideできる

### Internal link

* `[my link](@/xxx/yyy.md)`と書くと`content/xxx/yyy.md`にlinkを貼れる
  * `@/`はzola拡張?
  * linkが壊れていないかは`config.toml -> link_checker -> internal_level = "error"`でcheckしてもらえる`
 

## Configuration

* `config.toml`

TODO: ある程度固まったら書く

### Syntax highlight

```toml
[markdown]
highlight_code = true

highlight_theme = "nord"
```

* `config.toml`の`[markdown]`に
  * `highlight_code = true`を指定する
  * `highlight_theme = nord`で利用するhightlight themeを指定する
* highlightのcss styleはinlineで指定される


highlightのcssを自分で制御するには

```toml
[markdown]
highlight_code = true

highlight_theme = "css"

highlight_themes_css = [
  { theme = "nord", filename = "themes/nord.css" }
]
```

* `highlight_theme = css`を指定する`css`はzolaに特別扱いされる
  * zolaはcode blockにcss classの指定のみを行う
* `highlight_themes_css`を指定すると対象themeのcssを出力してくれるので自分でカスタマイズしたりできる
