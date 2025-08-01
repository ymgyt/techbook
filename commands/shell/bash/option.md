# bash

## option

* `set -e` : shortで有効
* `set -o errexit` longで有効
* `set +o errexit` longで無効

| long        | short | description                                                                     |
|-------------|-------|---------------------------------------------------------------------------------|
| `allexport` | `-a`  | 変数に代入すると自動的にexport                                                  |
| `errexit`   | `-e`  | 終了statusが0以外なら即座に終了                                                 |
| `noexec`    | `-n`  | 構文チェックonly                                                                |
| `nounset`   | `-u`  | 未定義変数を参照したときにエラー                                                |
| `pipefail`  |       | pipelineの戻り値が終了statusが0でない最後のコマンドの値になる                   |
| `xtrace`    | `-x`  | 変数展開をdebugする                                                             |
| `noglob`    | ?     | `echo Hello "${NAME} *"`のような場合に\*をliteralに扱う                         |
| `noclobber` | `-C`  | `echo "1" > important.txt` redirectによる既存のfileの上書きをできないようにする |
|  `errtrace`  | `-E` | trapを関数サブシェル内でも発火させる |

```bash
set -o nounset
set -o pipefail
set -o noclobber
set -o errexit
set -o errtrace

# 有効なoptionの表示
set -o
```
