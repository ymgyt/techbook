# DML


## `INSERT INTO ON DUPLICATE KEY UPDATE`

テーブルに指定してあるunique制約で重複した場合にはUPDATEできる。  
ONのあとに`VALUES`をかくとINSERTしようとした値を利用して更新ができる。  
**AUTO INCREMENTが設定されたcolumnの値が実際に新規のINSERTが走らなくても増加するので注意**

```sql
INSERT INTO `table_name` (col_1, col_2, col_3)
VALUES (1,1,1),(2,2,2),(3,3,3)
ON DUPLICATE KYE UPDATE
    col_1 = VALUES(col_1),
    col_2 = VALUES(col_2),
    col_3 = VALUES(col_3)
```

## `REPLACE INTO`

```sql
REPLACE INTO `table_name` (col_1, col_2, col_3)
VALUES (1,1,1),(2,2,2),(3,3,3)
```

`INSERT`と同じように機能するが、既存のテーブルにprimary keyかunique indexに関して  
新しい行と同じ値が含まれている場合、古い行はINSERT前に削除される。

* 削除される行の値は利用できない。INSERTに値がなければdefault値が利用される。
* AUTO INCREMENTの値がつねに増加することに注意。


## `TRUNCATE`

* **rollbackできない。**
* foreign keyがはられていると実行できない。
* **`AUTO_INCREMENT`値はリセットされる。  
* 削除された行数について意味のある値を返さない。
* `ON DELETE`triggerを発火させない。
* レプリケーション/binary loggingでは、`DROP TABLE`,`CREATE TABLE`として扱われる。(だからDDL扱いみたい)

```sql
TRUNCATE `table_name`
```

## Control flow

### CASE

* CASE value WHEN compare_value THEN result [WHEN  compare_value THEN result ...] ELSE result END

* CASE WHEN condition THEN result [WHEN condition THEN result ...] ELSE result END


### IF

* IF(expr1, expr2, expr3)

expr1がTRUE(0かNULLでない)とき、expr2を返し、それ以外はexpr3を返す

### IFNULL

* IFNULL(expr1, expr2)

expr1がNULLのときexpr2を返す

## User

### LIST

```sql
SELECT user FROM mysql.user;
```

### CREATE
```sql
CREATE USER 'user_xxx'@'localhost' IDENTIFIED BY 'passwordXYZ';
GRANT ALL PRIVILEGES ON *.* TO 'user_xxx'@'localhost' WITH GRANT OPTION;

CREATE USER 'user_xxx'@'%' IDENTIFIED BY 'passwordXYZ';
GRANT ALL PRIVILEGES ON *.* TO 'user_xxx'@'%' WITH GRANT OPTION;
```

### DROP

```sql
DROP USER 'user_xxx'@'%';
```

`user_xxx@localhost`と`user_xxx@%`は異なるユーザとして扱われる点に注意。
