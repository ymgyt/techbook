# set

```shell
# positional parameterのset
set -- 1 2 3

# Append args
set -- "${@}" "myarg"
```

* `set -o errexit`のようにoption指定もできるので、`--`を渡して明示的にpositionalであることを示す
* `"${@}"`との合わせ技で既存にappendもできる
