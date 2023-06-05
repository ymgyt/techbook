# Function


```sh
function foo() {
   local arg_1="$1" 

  return 1
}

foo "hello"
status=$? # status == 1

function hello() {
  echo "hello"
}

var=$(hello)
```

* 引数は`$1`でpositional同様に参照できる
* `local`でlocal scopeにできる
* `return`で関数の戻り値として終了statusを返せる
  * 呼び出し側は`$?`で参照できる
  * 省略したら直前のコマンドの終了status
* 値を返したい場合はstdoutに出力して呼び出し側で`$(f)`で使う
