# Helix Command


## 一時的にauto formatを無効にしたい

`:set auto-format false`してから`:write`したのち`:set auto-format true`

## 一時的にgitignoreされたfileをfile pickerで検索したい

`:set file-picker.git-ignore false`


## Selectionを外部のコマンドに渡して結果で上書きする

* `:pipe <cmd>`: selectionをstdinから渡して、cmdのoutputで置き換える
* `:sh <cmd>` shellの実行結果を表示する
* `:insert-output`: 結果をselectionの前に書き出す
* `:append-output`: 結果をselectionの後に書き出す

```sh
# markdownのtableをformatする
# tableをselectした状態で
# gfmはgithub flavor markdown
:pipe pandoc -t gfm
```
