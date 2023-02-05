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

## Local

* initdb時に指定しないとOSの設定が利用される
* `--no-locale` or `--locale=C`を指定してバイナリ値を利用するようにしておく

## Character Encoding

* `-E UTF-8`を指定する。(`initdb`の話?)
* Table作成時に指定する
  * AWS RDS等で`initdb`が使えない場合

```sql
CREATEDATABASE <dbname> 
    LC_COLLATE 'C'
    LC_CTYPE'C'
    ENCODING'UTF8' TEMPLATE template0;
```

## Access Controll

* `pg_hba.conf`で設定する
* defaultではlocalhost以外からのアクセスは無効になっている
* `posgresql.conf`からも設定できる?
