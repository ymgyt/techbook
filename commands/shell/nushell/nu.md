# Nushell

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
```

## Redirect

```sh
# Stdout
echo "Hello" out> out.text

# Stderr
echo "Warn" err> err.text

# Both
echo "Hello" out+err > log.log
```

* `>out` で出力先を指定する