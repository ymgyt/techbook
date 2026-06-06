# Nushell Environment Variable

* Nushellのenvironment variableはany type(stringとは限らない)
  * `$env.PROMPT_COMMAND`はclosure型

## Usage

```nu
# 表示
$env | table -e

# 設定
load-env { K1: "v1", K2: "v2"}

$env.AWS_REGION = "ap-northeast-1"

# PATH
$env.Path = ($env.Path | prepend "~/.local/bin")

# Default
$env.FOO? | default "BAR"

# Set判定
if "FOO" in $env {
  echo $env.FOO
}

# 実行command内でのみ有効
LOG=INFO run
# 同じ効果
with-env { LOG: INFO } { run }
```

* `load-env`をfileに書いて、`source`すると現在のsessionに反映できる
* `with-env`は第二引数のblockを第一引数のenvで実行する

```nu
# 関数で設定
def --env foo [] {
  $env.FOO = 'XXX'
}
```

* `def --env`とするとその関数で定義した環境変数が呼び出し側にも反映される
  * 通常は関数scopeになる


```sh
# 直近の終了code
$env.LAST_EXIT_CODE
```

## Change directory

`cd`でのdirectory変更は`PWD`環境変数の変更と同じ