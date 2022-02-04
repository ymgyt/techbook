# `pg_ctl`

* macだと`/Library/PostgresSQL/13/data`にinstallされる。(GUI Installer)
  * `postgres` userしか操作できないので, `sudo su postgres`でuserを変更する

## Postgres Serverの停止

```shell
pg_ctl -D /Library/PostgreSQL/13/data stop
```
