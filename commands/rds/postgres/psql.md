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
