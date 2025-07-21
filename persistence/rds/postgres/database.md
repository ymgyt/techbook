# Database

* Instance(Server)
  * Database
    * Schema
      * Table
      * View

* Database instanceの下にSchemaという名前空間がある
  * `schema.table`で参照


## `ALTER DATABASE`

```sql
ALTER DATABASE name SET parameter = value;
```

* `default_transaction_isolation`
  * `read uncommitted`, `read committed`, `repeatable read`, or `serializable`
