# Builtin

bashのbuildin

## command

```sh
command time xxx
```

* shellのfunctionを無視してbuiltinか`PATH`からのbinaryのみを実行する

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