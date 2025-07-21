# Collate

* 文字列データの比較規則を定める
  * 言語が違うとアルファベットの順番が違う
* 適用スコープ
  * Database
  * Table
  * Query

* `LC_COLLATE`
* `LC_CTYPE`

```sql
SELECT * FROM eployees ORDER BY name COLLATE "C";
```

* Collate
  * `C`: binary順
    * `["Banana", "apple"]` になる
  * `en_US.UTF-8`

* 実装
  * glibc
  * ICU(International Components for Unicode)


## Reference

* [AWS Blog](https://aws.amazon.com/blogs/database/manage-collation-changes-in-postgresql-on-amazon-aurora-and-amazon-rds/#:~:text=mathematical%20properties%2C%20but%20how%20does,where%20databases%20rely%20on%20collations)
