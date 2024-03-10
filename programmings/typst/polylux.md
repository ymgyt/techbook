# polylux

typstのslide用package

```typst
#import "@preview/polylux:0.3.1": *
#import themes.bipartite: *

#show: bipartite-theme.with(aspect-ratio: "16-9")

#set text(
  size: 25pt,
  font: (
    "Noto Sans CJK JP",
    // "Noto Color Emoji",
    // "JetBrainsMono Nerd Font",
))

#title-slide(
  title: [TUIのFeed Viewerを自宅サーバーで公開するまで],
  subtitle: [NixでRustの開発環境からCI,Deployまで管理する],
  author: [山口 裕太],
  date: [2024-03-05],
)

#west-slide(title: "自己紹介")[
  はじめまして
]

#east-slide(title: "概要")[
  概要を書く
]
```
