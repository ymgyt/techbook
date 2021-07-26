# DDL

## Data Types

### `TEXT`

* `TEXT`は最大が固定で、storage engineによるが参照で保持するのでrowの最大サイズ制限を回避できる。
* `TEXT`にはindex貼れるかについて制限がある。

### `VARCHAR`

* `CHAR`と違い可変長。長さを保持するので余計に1~2byte増える。
* `VARCHAR(10)`が実際に何bytesになるかはencodingによる。`utf8mb4`を指定したら1文字あたり4bytesになる。
* `TEXT`と違いindexをはれる。

### `CHAR`

* 固定長のデータ型。データをspaceでpaddingして固定長にする。
* 実データのspaceとpaddingのspaceは区別されず取得時に捨てられる。


## `CREATE TABLE`

CHARACTER SETとCOLLATEを明示的に指定したほうがよい。  
collateはunicode_520を使っておくとemojiにも対応できる。

```sql
CREATE TABLE IF NOT EXISTS `table`
(
     `id`           bigint unsigned NOT NULL AUTO_INCREMENT
    ,`tbl2_id`      bigint unsigned NOT NULL
    ,`created_at`   datetime        NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,`updated_at`   datetime        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ,PRIMARY KEY (`id`)
    ,FOREIGN KEY (`tbl2_id`) REFERENCES tbl2 (`id`) ON UPDATE CASCADE ON DELETE CASCADE
    ,CONSTRAINT my_unique UNIQUE (col_1, col_2)
)
    ENGINE = InnoDB
    CHARACTER SET utf8mb4           -- never use utf8
    COLLATE utf8mb4_unicode_520_ci  -- never use utf8mb4_general_ci
    COMMENT = 'DESCRIBE TABLE COMMENT';
```

* CHARACTER SETには `utf8mb4`を指定しておくのがよい。
* COLLATEには`utf8mb4_unicode_520_ci`を指定しておくとemoji対応ができる。

## `ALTER TABLE`

```sql

-- 外部キー制約の追加。
-- CONSTRAINTで明示的に名前をつけておくとDROPする際に参照できる。
ALTER TABLE `table` ADD CONSTRAINT `constraint_name` FOREIGN KEY (`fk_col`) REFERENCES `ref_tables` (`ref_col`);

-- 外部キー制約の削除。
ALTER TABLE `table` DROP FOREIGN KEY `constraint_name`;

-- columnの追加
ALTER TABLE `table` ADD COLUMN `new_column` <data_type> COMMENT '...' AFTER `prev_column`;

-- columnの削除
ALTER TABLE `table` DROP COLUMN <column>;
```

## `RENAME TABLE`

### Tableをswapする

一時的に別のtableにデータをINSERTしておき、tableをswapさせることができる。  

`old_table`と`new_table`をswapさせる。

```sql
RENAME TABLE old_table TO tmp_table,
             new_table TO old_table,
             tmp_table TO new_table;
```
