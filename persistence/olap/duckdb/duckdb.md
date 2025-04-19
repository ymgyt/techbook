# DuckDB

* SQLiteがembeddedなOLTPだとすると、DuckDBはembeddedなOLAP
  * SQLの実行能力をprocessに埋め込みたい

* `$HOME/.duckdbrc` にrc fileをおける


## Usage

```sh
# queryを実行して、結果をjsonで出力
cat query.sql | duckdb -json

# commandの実行
duckdb -c '.read query.sql' --json
```
* command 実行
  * `-s` or `-c`
* output format
  * `json`,`markdown`, `csv`

### REPL

```sh
# fileからqueryを実行
.read query.sql

# 出力modeの変更
.mode line
.mode duckbox
```

## Query

### parquetを読む

```sql
SELECT t.*
FROM read_parquet('s3://my-bucket/*/*.parquet) AS t
LIMIT 10;
```

### Tableのsummarize

```sql
SUMMARIZE FROM <table>
```

## Extensions

```sql
INSTALL httpfs;
LOAD httpfs;
```

### httpfs

* S3を読みに行けるようになる

```sql
SELECT *
FROM 'https://github.com/ymgyt/data/raw/main/foo.csv';

-- csv を指定
SELECT *
FROM read_csv_auto('https://path/to/data')
```

## Reference

* [DuckDB: an Embeddable Analytical Database](https://mytherin.github.io/papers/2019-duckdbdemo.pdf)
