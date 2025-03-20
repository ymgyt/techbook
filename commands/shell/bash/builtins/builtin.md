# Builtin

bashのbuildin

## command

```sh
command time xxx

command -v hello
```

* shellのfunctionを無視してbuiltinか`PATH`からのbinaryのみを実行する
* `-v` optionをつけるとwhichと同じように実行path表示してくれる

## type

`type name...`で引数のnameの種別(alias, function, builtin, file)等を表す

```sh
type type
type is a shell builtin
```


## read

userの入力を読み取る。引数の変数に格納してくれる 

```sh
echo "Input: "
read USER_INPUT
echo "I got ${USER_INPUT}"
```

`read -p`で同じことができる。zshだと動かないので注意

```sh
read -p "Input" input
echo ${input}
```

`read -n1`でなにか1文字おされたら反応するような挙動にできる  
`-s`をつけると入力のfeedbackを抑制できる

```sh
read -sn1 -p "Press any key to exit"
echo "Exit"
```


## set

```shell
# positional parameterのset
set -- 1 2 3
```

* `set -o errexit`のようにoption指定もできるので、`--`を渡して明示的にpositionalであることを示す

## shift

```shell
# positional parameterを一つ破棄する
shift

# 破棄する数を指定する
shift 2

# 全てを破棄する
shift $#
```

## trap

signal handlingを設定できる

```sh

trap '
    echo "Handle signal"
    exit 1
' SIGINT
```

* `trap '<commands>' <signals>`: signalの指定方法はkill -lと同じ。

### 疑似signal

OSのsignalとは別にbashの仕組みとして、trapに指定できるsignal

* `EXIT`: script終了時
* `ERR`: コマンドの終了ステータスが0以外
* `DEBUG`: コマンドが実行された 

## exec

* commandを新しいprocess ではなく自プロセスとして実行する
  * fork execのexec
* wrapper scriptでよく使う

```sh
exec command
```
