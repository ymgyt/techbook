# test

いろんな判定。
https://ss64.com/bash/test.html


```sh
# directoryが存在するか
test -d $DIR

```

| Param | Description                     |
|-------|---------------------------------|
| `-d`  | directoryが存在するか           |
| `-z`  | 変数がunset or emptyかどうか    |
| `-n`  | stringがnot emptyでなければtrue |
| `-e`  | fileが存在するか                |

file関連

| Param | Description                 |
|-------|-----------------------------|
| `-d`  | directoryが存在するか       |
| `-e`  | fileが存在するか            |
| `-L`  | fileが存在してsymbolic link |


```sh
if [ "foo" != "bar" ]; then
  echo "Not Equal"
fi
```


# `[ ]`と`[[ ]]`の違い

* `test`と`[` は基本同じ
* `[[`は`[`の拡張
  * POSIXではない

* 基本的には`[[`を使うでよい
  * `>`が比較ではなくredirectと解釈される
  * パターンマッチ、正規表現マッチが使えない
  * `&&`, `||`が使えない


```sh
# A AND (B OR C)
[[ -f $file1 && ( -d $dir1 || -d $dir2 ) ]]

if ! [[ -d $dir ]]
```

# `if`

```
if COMMANDS; then COMMANDS; 
[ elif COMMANDS; then COMMANDS; ]… 
[ else COMMANDS; ] fi
```

ifは引数のcommand listを実行して、終了ステータスによって分岐しているだけ。
