# bash

## recipe

### commandがinstallされているか

```
command -v docker > /dev/null || { echo "dockerをインストールしてください"; exit 1; }
```

### check

```shell
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

### iterate array

tuple的なデータ構造をiterateする。

```shell
ary=(
    "one;hoge"
    "two;bar"
)

for item in ${ary[@]}
do
    IFS=";" read -r -a tmp <<< "${item}"
    var1=${tmp[0]}
    var2=${tmp[1]}
    echo "${var1}: ${var2}"
done
```

### scriptのある絶対pathを取得する

```shell
CWD=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
```

### fileに定義した環境変数をすべてexportする

`../.env`に変数定義がある前提。

```shell
set -o allexport 
. ../.env 
set +o allexport
```

### コマンドがinstallされているかの確認

```shell
command -v "${cmd}" > /dev/null || fail "${cmd} required"
```

### 引数を空の場合を考慮しつつ引き回す

`${@}`とだけしてしまうと、引数がない場合に `""`が渡されたものとして扱われてしまうので、variable substitutionをかませる。

```shell
function main() {
  # check pre conditions
  check_args ${@+"$@"}
  check_deps
  // ...
}

main ${@+"$@"}
```


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
