# psql

## Install

```console
# mac
brew install libpq
brew link --force libpq
```

## Connection

```sh
# postgresdb databaseに接続する。
psql --port=32488 --host=localhost   --username=admin --password postgresdb

# file内のsqlを実行する
PGPASSWORD="$password" psql --username $user --dbname $dbname --host $host $port_flag -f path/to/sql.sql

```

## Commands

* `\l`: list databases
* `\dt`: list tables
* `\duS`: list users(roles)
* `\du` : 権限(priviledge)確認
* `\c<dbname>`: connect database
* `\x`: display形式の変更。縦に伸びる。
* `SHOW SEARCH_PATH`

### Table

```sh
# schema内のtable一覧
\dt myschema.*;

# table定義
\d myschema.table_a;
```

### Roles

```sh
# list roles
\du
```

### Schema

```sh
# list schemas
\dn;
```

### Privileges

```sh
# schema配下のpriviledgeを確認
\dp myschema.*;
```

### Shell

```sh
\! pwd
```

### 調査系

```sh
# Version check
SELECT VERSION();

# Isolation level
 SHOW default_transaction_isolation;  
```
