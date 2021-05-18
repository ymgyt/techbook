# control flow

## if

```shell

if [ "$i" -eq 3 ]; then
  echo "3"
elif [ "$i" -eq 5]; then
  echo "5"
else
  echo "else"
fi

#これもあり
if who | grep '^guest\>' > /dev/null
then
  echo "guest login"
fi
```

then, elseの後の改行は区切り文字としての改行であり、リストの終端ではない。ここに;をいれるとエラー

## forループ

```shell
for n in $(seq 1 10); do
    echo ${n};
done

for ((n=1; n<=100; n++));
do
    echo ${n};
done


# 対象を別fileにしておき
for file in `cat files` ; do

# すべての引数を対象にするには
for arg in "$@" ; do
```
doのあとのlistは改行されていなければ; がdoneの前に必要
doのあとに;はいらない

## case

```shell
case "$var" in
  "yes"|"YES")
    処理1
    ;;
  "bb" )
    処理2
    ;;
  "c c c" )
    処理3
    ;;
  *)
    echo "else"
    ;;
esac
```

## while

whileのあとのcommandが0を返すと処理に入る

```shell
DATA=`cat /tmp/data`
while read line
do
    dosomething ${line}
done << EOF
${DATA}
EOF
```


### infinite loop

```shell
while true
do
  # process
done
```
