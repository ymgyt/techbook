# Bash Variables

## Substitution

* `${VAR:? environment variable VAR required}`: ない場合にエラーだせる
* `${VAR:-default}`: `VAR`がない場合に`default`を返せる

## `$_`

直前のcommandのlast argumentが展開される。  
argumentがなければ直前のcommnad.

```shell
mkdir xxx && cd $_
```

`cd xxx`に展開される。ほとんどオシャレ用。

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
