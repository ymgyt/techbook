# mapfile

* 入力を1行ずつ読み取って配列にいれる
* `readarray` alias

```sh
mapfile results < data.txt

mapfile -d '' -t results < <(find out -name foo.json -print0)
if (( ${#results[@]} == 0 )); then
  echo '[]'
else
  jq --slurp '.' "${results[@]}"
fi
```

* `-t` 要素の末尾にdelimiterをつけない
* `-d` delimiter指定
  * `-d ''`とするとNULL 区切り
  * `find -print0`と組み合わせる
