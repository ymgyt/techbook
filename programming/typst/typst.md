# typst

## Install

```sh
brew install typst
```


## Reference

https://typst.app/docs/reference/


## Usage

```sh
# create note.pdf
typst note.typ 

# watch
typst watch note.typ

# Nix
nix run github:typst/typst watch matrix.typ
```

## Syntax

```
= Heading
content xyz

== Heading 2

+ item 1
  - bullet item 1-1
  - bullet item 1-2
+ item 2
+ itme 3

line-1 \
line-2
```

* 改行は`\`
* code blockはmarkdownと同じ(書くと壊れるので書けない..)

## 設定

### Font

```
#set text(font: "New Computer Modern")

```

## File分割

* `#include path/to/note.typ`: そのfileのcontentを展開できる

### Text

```typst
// hogehogeをgray outで表示
#text(fill: gray.lighten(50%), [hogehoge])
```
