# MySQL

* [DDL](./ddl.md)
* [DML](./dml.md)  
* [tips](./tips.md)

## Character Sets

character setとは表現できる文字とそのencodingを組み合わせたもの。  
MySQLでは、Server,DB,Table,Column単位でcharacter setとcollationを指定できる。  
各character setはdefaultのcollationをもっており、collationが指定されていない場合はdefault値が利用される。


### MySQLの`utf8`はUTF8じゃない

**MySQLにおける`utf8`はBMPだけしか扱えないので、`utf8mb`を使うこと**

```sql
SHOW CHARACTER SET WHERE Charset like 'utf8%';

-- utf8とutf8mb4が表示される
```

### Collation

**collation(照合順序)とは文字の比較のためのルールを集めたもの。**

* `SET NAMES 'utf8'`を実行すると、client/server間のcharacter setを指定できる。
* `_ci`で終わるcollationは大文字と小文字を区別しない。case insensitive
* `_bin`で終わるcollationは文字binary code値にしたがう。


文字コード(utf8mb4)に対応する一覧を取得する
```sql
SHOW COLLATION WHERE Charset = "utf8mb4"
```


### char/varcharの`BINARY` 

`BINARY`を付与するとそのcharacter setのbinary collationが利用される。  
すべてのcharsetはbin collationをもっている。以下の定義は同じ意味をもつ。

```sql
VARCHAR(10) BINARY
VARCHAR(10) CHARACTER SET latin1 COLLATE latin1_bin
```

## `ANALYZE TABLE`

統計情報を更新するらしいが、よくわかってないので調べたい。

## `CASE`式

式なので、任意のexpressionを書けるところに書ける。

```sql
--単純CASE式
CASE sex
WHEN '1' THEN '男'
WHEN '2' THEN '女'
ELSE 'その他'
END
```

```sql
--検索CASE式
CASE WHEN sex = '1' THEN '男'
WHEN sex = '2' THEN '女'
ELSE 'その他' END 
```

## `WITH`

INNER JOINじゃなくて先に一時テーブルを書ける。

```sql
WITH aaa AS 
(
    SELECT * FROM xxx
)
, bbb AS 
(
    SELECT * FROM yyy
)
SELECT ccc.*, aaa.A, bbb.B
FROM ccc
```
