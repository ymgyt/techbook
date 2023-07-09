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
* `\c<dbname>`: connect database
* `\x`: display形式の変更。縦に伸びる。
