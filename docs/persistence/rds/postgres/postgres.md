# Postgres

## Connection URL

https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING

```text
postgresql://<user>:<pass>@<host>:<port>/<dbname>?key1=value1&key2=value2
```

example

```text
postgresql://other@localhost/otherdb?connect_timeout=10&application_name=myapp
```

libpqがこのURLを要求しているので、基本的にどのtoolもこれを要求されると思われる。(wrap等していなければ)

## Version Check

```sql
SELECT version();

version
-------------------------------------------------------------------------------------------------------------------------------
PostgreSQL 11.14 (Debian 11.14-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)
```
