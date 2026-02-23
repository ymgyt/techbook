# Process Substitution

```sh
scripts.sh < <(gen-file.sh)
```

* `<(...)`の出力を一時ファイルに書き出し、FDとして扱えるようにする
* 入力がfileを前提にしている場合に動的にファイルを作れる
