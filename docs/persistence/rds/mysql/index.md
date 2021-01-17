# MySQL

* [tips](./tips.md)

## Character Sets

character setとは表現できる文字とそのencodingを組み合わせたもの。  
MySQLでは、Server,DB,Table,Column単位でcharacter setとcollationを指定できる。  
各character setはdefaultのcollationをもっており、collationが指定されていない場合はdefault値が利用される。


**collation(照合順序)とは文字の比較のためのルールを集めたもの。**

* `SET NAMES 'utf8'`を実行すると、client/server間のcharacter setを指定できる。  
* `_ci`で終わるcollationは大文字と小文字を区別しない。
* `_bin`で終わるcollationは文字binary code値にしたがう。


### char/varcharの`BINARY` 

`BINARY`を付与するとそのcharacter setのbinary collationが利用される。  
すべてのcharsetはbin collationをもっている。以下の定義は同じ意味をもつ。

```sql
VARCHAR(10) BINARY
VARCHAR(10) CHARACTER SET latin1 COLLATE latin1_bin
```
