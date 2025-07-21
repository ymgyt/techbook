# Schema

* Schemas are analogous to directories at the operating system level, except that schemas cannot be nested.

## DDL

```sh
CREATE SCHEMA IF NOT EXISTS myschema AUTHRIZATION someone;
```

## Public schema

* schemaを指定しない場合、publicが利用される

## Schema Search Path

* tableだけが指定された場合は`search_path`からschemaを探す
* 確認するには `SHOW search_path;`

```sql
SHOW search_path;

SET search_path TO myschema, public;
```

## References

* [Manual](https://www.postgresql.org/docs/17/ddl-schemas.html)
