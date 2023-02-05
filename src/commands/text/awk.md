# awk


## variable

* `$0` 行全体
* `$1` field separatorで区切ったcolumn

## option

### `-F`

field separatorの指定
``echo "a,b,c" | awk -F',' '{print $2}'``  #=> b
正規表現が指定できる。cutとの最大の違い

```
echo "2017/01/02 12:13:14" | awk -F'[ :/]' '{print $2}' # => 01
```

### `-v`

変数を渡せる

```
NAME="target"
awk -v name=${NAME} '{if($2==name) {print $0}'
```

## recipe

### psの足し込み

連想配列をnaturalにサポートしていて、forでkeyをiterateできる
```
ps aux | awk '{ if(NR > 1) {m[$1] += $4; n[$1]++}} END { for(i in m) { print m[i], n[i], i }}'
```


### 重複行をソートして出力

可変長対応で、いらないところ落とす

``gawk '{ t[$0]++ } END{ for(k in t){ printf "%5d %s\n",t[k],k } }' | sort -nr``


