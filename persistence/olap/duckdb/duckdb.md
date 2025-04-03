# DuckDB

* SQLiteがembeddedなOLTPだとすると、DuckDBはembeddedなOLAP
  * SQLの実行能力をprocessに埋め込みたい


## Usage

```sh
# queryを実行して、結果をjsonで出力
cat query.sql | duckdb -json
```

* output format
  * `json`,`markdown`, `csv`

### REPL

```sh
# fileからqueryを実行
.read query.sql
```

## Query

### parquetを読む

```sql
SELECT t.*
FROM read_parquet('s3://my-bucket/*/*.parquet) AS t
LIMIT 10;
```


## Reference

* [DuckDB: an Embeddable Analytical Database](https://mytherin.github.io/papers/2019-duckdbdemo.pdf)
