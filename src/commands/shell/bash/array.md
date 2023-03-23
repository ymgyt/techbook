# array

## 宣言

```shell
list=(aaa bbb ccc ddd)

# 空
list=()

declare -a ary
```

## 参照

```shell
ary=(aaa bbb ccc)
echo ${ary[1]}

# index 0とみなされる
echo ${ary}

# 要素数
echo ${#ary[@]}

# 個別文字列として展開
echo "${ary[@]}" # => "aaa" "bbb" "ccc"

# ひとつの文字列として展開
echo "${ary[*]}" # => "aaa bbb ccc"

# 値の存在するindexの取得
echo ${!ary[@]} # => 1 2 3
```


## 要素の追加

```shell
ary=(aaa bbb ccc)
echo ${ary[@]}

ary=("${ary[@]}" ddd eee)
echo ${ary[@]}

ary=(xxx yyy "${ary[@]}")
echo ${ary[@]}
```

# Associative array

いわゆる連想配列。

```shell
declare -A ary=(
  [key_1]=value_1
  [key_2]=value_2
)

for key in ${!ary[@]}; do 
  local value=${ary[${key}]}
done;
```

* `${!ary[@]}`でindex(=key)を参照できる

