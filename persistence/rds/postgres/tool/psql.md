# psql

## Install

```console
# mac
brew install libpq
brew link --force libpq
```

## Connection

```console
# postgresdb databaseに接続する。
psql --port=32488 --host=localhost   --username=admin --password postgresdb
```

## Commands

* `\l`: list databases
* `\dt`: list tables
* `\duS`: list users(roles)
* `\du` : 権限(priviledge)確認
* `\c<dbname>`: connect database
* `\x`: display形式の変更。縦に伸びる。
* `SHOW SEARCH_PATH`

### 調査系

```sh
# Version check
SELECT VERSION();


  
```
