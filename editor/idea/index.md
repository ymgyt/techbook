# IDEA

## メモリ設定

* file sizeが大きい場合Intellijが補完の対象にしてくれない場合がある(巨大なSDKとか)
  * Help > Edit Custom Propertiesで設定値を変更できる

```text
# 単位はKB
idea.max.content.load.filesize=100000
idea.max.intellisense.filesize=20000
```

## Key bind

### Tab

* `Move to Oppsite group`: tabを別のwindow?にうつす。
* `Streach to (Top|Bottom)`: activeなwindowのsizeを変更する。terminalの調整に便利
  * Ctrl+Opt+(↑|↓)

### Code

* Expand CodeBlock: `Cmd -` / `Cmd =`

### Navigate

* Goto (Previous|Next Splitter): となりのwindow(splitter)に移動する
* Switcher: Ctrl+Tab: 色々切り替えるモード。Ctrl押しっぱなしで継続するTabで移動する。deleteで候補から消せる
* Jump to Navigation Bar: Cmd+↑ 上段のfile treeから移動できる
* Next Highlight Error: F2 エラーにとべる

## Action

* Show Context Actions: Meta+Enter エラー出ていたりする場合適切なアクション選べる。

## Appearance

* Quick Switch Schema: "Ctrl+`" 見た目系を色々変更できる

## Vim

`~/.ideavimrc`を作成しておく

```text
# yankでclipboardにcopyされるようにする
set clipboard+=unnamed
```
