# Bash Variables

## Positional Parameter

* -`$#`: 引数(positional parameter)の数

```shell
# parameterのset
$ set -- 1st 2nd 3rd 4th
```

### `$*`, `"$#"`, `$@`, `"$@"`

* `$*`, `$@`は同じ
  * 引数を全て展開後にword分割、path名展開が適用される

* `"$@"`: `"$1" "$2" "$3"`のように引数がそれぞれ展開される

* `"$*"`: `$1c$2c$3`のように引数が全て`IFS`の最初の文字で連結されて一つの文字として展開される。defaultはspace