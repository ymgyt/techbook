# sed

set [option] <script> file

scriptはaddressとactionからなる.adressを省略したらfile全体

* `-r` 拡張正規表現を利用する
* `-e` scriptを指定する
* `-i` fileを上書き保存する


```shell
# scriptの複数指定
sed -e 's/:/,/g' -e s/bin//g' /etc/passwd

# fileの直接編集
sed -i 's/XXX/YYY/g' name.txt

# backupをとっておく name.txt.backができる
sed -i.bak 's/XXX/YYY/g' name.txt
```

## Usage

```shell
# 1~5行目を削除
sed -e 1,5d      
# 先頭hogeの文字列をカット 
sed -e /^hoge.*/d 
# でstartパターンからendパターンまでを表示
sed -n /<start>/,/<end>/p 
```

### Substitute

```shle
# _を改行コード
echo 'aaa_bbb' | sed -e 's/_/\n/g'
```
