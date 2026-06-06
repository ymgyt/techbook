# Nushell

## Install

```sh
cargo install nu
```

## Alias


## Usage

```sh

# CPU使用率が高いprocessを表示
ps | where cpu > 20 

# 再起的に検索する
ls **/*.md

# 外部コマンドを呼び出すには^をつける
^echo

# 結果をfileに書き出す
"hello" | save output.txt
```

## Variables

* `$nu`
 * `$nu.home-path`

### String interpolation

stringの中で変数参照するやつ

`$"hello ($variable)"`  
`$""`で囲んで、その中で`($var)`で参照する

### Environment variable

```
echo $nu.env

$env.FOO = "foo"
$env.FOO 

hide-env FOO
```

## Command substitution

```sh
nix-store --query (which sqlite3 | get path)
# こうもかける
nix-store -q ((which sqlite3).path)
```

* `()`の評価結果を利用できる
  * 構造化データをstringにする処理忘れがち

## Pipeline

```nu
> [1 2 3] | $in.1 * $in.2
6
```

* `$in`は自動で定義されてpipelineのinputを評価できる


## Operator

* `=~` 正規表現でmatch
  * `"foo-bar" =~ "-bar$"` => true


## Escape new line

```sh
foo \
  --arg1 \
  --arg2 
```

は

```nu
(
  foo
    --arg1
    --arg2
)
```

* `( )`で囲む

## Script


```nu
def main [] {
 
} 
```
* `nu script.nu`で実行する
* scriptに`main`が定義されていると実行される(特別扱い)
  * mainがない場合は明示的な呼び出しのcodeが必要。bashと同じ

