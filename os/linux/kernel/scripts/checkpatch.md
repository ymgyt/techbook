# checkpatch.pl

* [Doc](https://docs.kernel.org/dev-tools/checkpatch.html)

## Usage


```sh
./scripts/checkpatch.pl path/to/change.rs

# debug
# 使い方わかってない
scripts/checkpatch.pl --debug values=1 --debug possible=1 --debug type=2 --debug attr=2 ...

```

* `--list-types`
  * check対象のvariant(type)を表示
* `--ignore TYPE1,TYPE2`
  * 特定のcheckを無視
* `--use TYPE1,TYPE2`
  * 特定のcheckのみを実行

* `--no-tree`
  * kernel tree外で実行する
* `--root <kernel tree path>`
  * kernel treeを指定する
  * `--no-tree`を指定しない限り、カレントかこの値がkernel treeをさす必要がある

* `--typedefsfile`
  * 追加の型を読む場合に指定する(用途不明)

* `--file|-f`
  * fileをsource codeとして扱う
* `--git|-g`
  * fileをgit commitとして扱う

* `--fix`: 修正版を出力してくれる？

* `--showfile`
  * よくわかってない
