# Generate Plantuml Script


```shell
#!/bin/bash

# plantumlの画像ファイルを生成する。
# java, graphviz(dot), plantuml.jarがinstallされていることを前提にしている。
# 引数
# $1: plantuml.jar
# Example
# generate_puml.sh path/to/plantuml.jar

set -o nounset

# 生成対象のソース。
GENERATE_TARGETS=(
  "xxx.puml"
)

SOURCE=${BASH_SOURCE[0]}
CWD="$(cd "$(dirname "${SOURCE}")" && pwd)"
USAGE=$(cat <<EOF
Usage:
${SOURCE} <path/to/plantuml.jar>
EOF
)

function fail() {
  echo "$1"
  exit 1
}

function check_args() {
  if [ "$#" -ne 1 ]; then
    echo "arg(s) required"
    fail "${USAGE}"
  fi

  if [ ! -f "$1" ]; then
    fail "plantuml.jar path required"
  fi
}

function check_command() {
  local cmd="$1"
  command -v "${cmd}" > /dev/null || fail "${cmd} required"
}

function check_deps() {
  check_command "java"
  check_command "dot"
}

# plantumlの起動処理。
function generate_image() {
  local plantuml_jar="$1"
  local src="$2"

  # 生成するファイル種別
  local specs=(
    "-tpng;.png"
    "-tsvg;.svg"
  )

  for spec in "${specs[@]}"
  do
    IFS=";" read -r -a tmp <<< "${spec}"
    local opt=${tmp[0]}
    local ext=${tmp[1]}
    local dst="${CWD}/dist/${src%%.*}${ext}" # 拡張子の変換 .puml => .png

    # footerに生成時の時刻をいれる
    # themeは指定があればコメントアウトはずす
    < "${CWD}/${src}" sed -e "s/'__FOOTER/footer Generated at $(date)/" | \
    sed -e "s/'__THEME/'!theme materia-outline/" | \
    java -jar "${plantuml_jar}" "${opt}" -pipe > "${dst}"  || fail "failed to generate image"

    echo "${dst} successfully generated"
  done
}

# 生成対象のumlの画像を生成する。
function generate_images() {
  local plantuml_jar="$1"

  for target in "${GENERATE_TARGETS[@]}"
  do
    read -r -a tmp <<< "${target}"
    local target=${tmp[0]}
    local src="${CWD}/${target}"


    generate_image "${plantuml_jar}" "${target}"
  done
}

function main() {
  # check pre conditions
  check_args ${@+"$@"}
  check_deps

  local plantuml_jar=${1}

  echo "generate plant uml image file..."

  generate_images "${plantuml_jar}"

  echo "OK"
}

main ${@+"$@"}
```
