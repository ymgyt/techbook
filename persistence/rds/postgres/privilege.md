# Priviledges

* objectが作成されるとownerに所属する
  * 通常は作成したrole
  * 初期状態では、ownerしかアクセスできないので、明示的な権限付与が必要


* Privileges
  * SELECT
    * カラムを`SELECT`するのに必要
    * INSERT,UPDATE時のcolumnの参照にも必要
  * INSERT
  　* `INSERT`に必要
  * UPDATE
    * `UPDATE`に必要
  * DELETE
    * `DELETE`に必要
  * TRUNCATE
    * `TRUNCATE`に必要
  * REFERENCES
    * foreign key constraintの作成に必要
  * TRIGGER
    * table,viewへのtriggerの作成に必要
  * CREATE
  　* For databases
      * schemaの作成を許可
    * For schemas
      * objectの作成を許可
  * CONNECT
  * TEMPORARY
  * EXECUTE
  * USAGE
  * SET
  * ALTER SYSTEM

## GRANT

```sql
GRANT UPDATE ON accounts TO joe;
--- 指定するかわりに全部付与
GRANT ALL ON accounts TO joe;

--- 取り消し
REVOKE ALL ON accounts FROM PUBLIC;
```

## Examples

```sql
ALTER TABLE table_name OWNER TO new_owner;
```
