# Bash

## option

* `set -e` : shortで有効
* `set -o errexit` longで有効
* `set +o errexit` longで無効

| long        | short | description                             |
| ---         | ---   | ---                                     |
| `allexport` | `-a`  | 変数に代入すると自動的にexport                      |
| `errexit`   | `-e`  | 終了statusが0以外なら即座に終了                     |
| `noexec`    | `-n`  | 構文チェックonly                              |
| `nounset`   | `-u`  | 未定義変数を参照したときにエラー                        |
| `pipefail`  |       | pipelineの戻り値が終了sutatusが0でない最後のコマンドの値になる |
| `xtrace`    | `-x`  | 変数展開をdebugする                            |

## control flow

```shell
# check arg count
if [ "$#" -ne 1 ]; then
  echo "arg(s) required"
fi

# fail exists/not exists
if [ ! -f "$1" ]; then
  fail "xxx path required"
fi
```
