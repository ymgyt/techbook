# DDL

## `CREATE EXTERNAL TABLE`

テーブルの作成。

```text
CREATE EXTERNAL TABLE [IF NOT EXISTS]
 [db_name.]table_name [(col_name data_type [COMMENT col_comment] [, ...] )]
 [COMMENT table_comment]
 [PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)]
 [CLUSTERED BY (col_name, col_name, ...) INTO num_buckets BUCKETS]
 [ROW FORMAT row_format]
 [STORED AS file_format] 
 [WITH SERDEPROPERTIES (...)] ]
 [LOCATION 's3://bucket_name/[folder]/']
 [TBLPROPERTIES ( ['has_encrypted_data'='true | false',] ['classification'='aws_glue_classification',] property_name=property_value [, ...] ) ]
```

* `EXTERNAL`: tableとなるfileがexternal(S3)にあることを指定する。
  * s3の場所は`LOCATION`で指定する
  * `CREATE TABLE AS`以外はすべて`EXTERNAL`  
  * 保存されるfileのformatは、`STORED AS`等で指定する  

* `[IF NOT EXISTS]`: tableが既に存在していてもエラーにならない
* `[db_name].table_name`: 作成するtable名を指定。`db_name`を省略したら、現在のdatabaseがassumed。
  * 数字がはいっている場合、"table123"のようにquoteする。
  * Athenaはcase insensitive
    
* `[(col_name data_type [COMMENT col_commnet] [,...])]`: `data_type`は以下
  * `BOOLEAN`. `true` or `false`     
  * `TINYINT`. 8bit signed `INTEGER` 
  * `SMALLINT`. 16bit signed `INTEGER`
  * `INT`. 32bit signed. DDLでは`INT`, queryでは`INTEGER`を使うらしい。
  * `BIGINT`. 64bit signed `INTEGER`
  * `DOUBLE/FLOAT`.
  * `DECIMAL`. precisionとscaleを指定できる。 
  * `CHAR`. fixed length character. 1から255までを指定できる。`char(10)`
  * `VARCHAR`. variable length character data. 1かｒ65535までを指定できる `varchar(10)`
  * `STRING`.   
  * `BINARY`. for data in parquet  
  * `DATA`. ISO format. `YYYY-MM-DD`(`DATE '2021-09-15'`)
  * `TIMESTAMP`. `java.sql.Timestamp` compatible format. `yyyy-MM-dd HH:mm:ss[.f...]` (`TIMESTAMP '2008-09-15 03:04:05.324' `)
  * `ARRAY <data_type`
  * `MAP <primitive_type, data_type` 
  * `STRUCT <col_name: data_type [COMMENT col_comment] [,...]>`  

* `[PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)]`. partitioned tableを作成する。
  * partitioned columnsはtable data側には存在しない、`col_name`が同じだとエラーになる。
    
* `[CLUSTER BY (col_name, col_name, ...) INTO num_buckets BUCKETS]`
* `[ROW FORMAT row_format]`: 正規表現書いたり、delimiterを指定したりできる。
* `[STORED AS file_format]`: table dataのformatを指定する。省略されたら`TEXTFILE`になる。
  * `PARQUET`: parquet対応。
    
* `LOCATION 's3://bucket_name/[folder]/` : underlying dataのs3を指定する。
  * trailing slashをつけたbucket or directoryのpathである必要がある。
    
* `[TBLPROPERTIES]`: よくわかってない。
    

example

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS cloudfront_logs (
  `Date` DATE,
  Time STRING,
  Location STRING,
  Bytes INT,
  RequestIP STRING,
  Method STRING,
  Host STRING,
  Uri STRING,
  Status INT,
  Referrer STRING,
  os STRING,
  Browser STRING,
  BrowserVersion STRING
  ) 
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
  WITH SERDEPROPERTIES (
  "input.regex" = "^(?!#)([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+[^\(]+[\(]([^\;]+).*\%20([^\/]+)[\/](.*)$"
  ) LOCATION 's3://athena-examples-myregion/cloudfront/plaintext/';
```

## DROP TABLE

```sql
DROP TABLE [IF EXISTS] table_name
```
