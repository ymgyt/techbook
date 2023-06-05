# Bash Recipe

## recipe

### commandがinstallされているか

```
command -v docker > /dev/null || { echo "dockerをインストールしてください"; exit 1; }
```

### check

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

### Header

```shell
#!/bin/bash

set -o nounset
set -o pipefail
set -o errexit
```

シェバンは`env`をかませるとかしたほうがいいかもしれない。


### Output as file

* コマンドの実行結果をfileにみせる

```shell
diff <(cat A.txt) <(cat B.txt)
```

