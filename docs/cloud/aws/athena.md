# Athena

* S3においてあるデータにSQLでQueryをうてるサービス。
* 内部的にはPrestoを使っている。
* schema-on-read approach

## memo

* S3のstorage classには影響されない
  * (Standard, Standard-IA, Intelligent-Tiering)
  * Glacier, Glacier Deep Archiveはサポートしない
    * Glacierは無視される。
    * Glacier Deep Archiveにデータがあるとエラー。
    
* partitionedしていないと、S3のGet requestでexceptionになるかも。
* functionはpresto準拠
    

## SQL

### DDL

#### `CREATE EXTERNAL TABLE`

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

#### DROP TABLE

```sql
DROP TABLE [IF EXISTS] table_name
```

### CTAS

`CREATE TABLE AS SELECT` queryの結果を利用してテーブルを作成できる。

## Partition

* tableを日付や、国といったcolumnの値単位でまとめることをさす。
* partitionは仮想columnとして機能する。
* 原則は、s3のroot folderからpartitionとしてさらにsub folderをきって、queryの`WHERE`句で指定する。`WHERE`句にpartitionが指定されていた場合、Athenaはpartitionに対応したsub folderからしかdataをreadしない。  
結果的にperformance向上とcost削減に寄与する。

* defaultのpartition数のlimitはtableあたり20,000。あげる場合はrequestが必要。
* 指定方法は`s3://yourBucket/pathToTable/<PARTITION_COLUMN_NAME>=<VALUE>/<PARTITION_COLUMN_NAME>=<VALUE>/`
  * この方式の場合、`MSCK REPAIR TABLE`を実行してpartitionを一括で認識させる
    
* partitionを単一かつstringにしておくと最適化がきくらしい

### Partitionの更新

２つの方法がある。

* `MSCK REPAIR TABLE <table_name>` を実行。
  * すべてのpartitionが有効化される(athenaで認識される)
    
* `ALTER TABLE <athena_database>.<athena_table> ADD IF NOT EXISTS PARTITION (key=value, [key=value,...])`
  * 追加したpartitionがわかっているときはこれで明示的に作成できる。
    
    
### 考慮事項

* フィルタとして使われるカラムは、パーティションの有力候補になります
* パーティショニング自体にコストがかかります。テーブル内のパーティション数が増えるにつれ、パーティションのメタデータを取得して処理するためのオーバーヘッドが大きくなり、かつ 1 パーティションあたりのデータサイズは小さくなります。過剰に細かくパーティショニングすると、パフォーマンス上の利点が失われます
* データが特定パーティションに偏っており、かつ多くのクエリがその値を使う場合には、同様にパフォーマンス上の利点が失われます

### Partition projection

よくわってない。必要ならこれ読む。  
https://aws.amazon.com/blogs/big-data/speed-up-your-amazon-athena-queries-using-partition-projection/

### 具体例

s3 
```text
aws s3 ls s3://elasticmapreduce/samples/hive-ads/tables/impressions/
    PRE dt=2009-04-12-13-00/
    PRE dt=2009-04-12-13-05/
    PRE dt=2009-04-12-13-10/
    PRE dt=2009-04-12-13-15/
    PRE dt=2009-04-12-13-20/
    PRE dt=2009-04-12-14-00/
    PRE dt=2009-04-12-14-05/
```

ddl
```
CREATE EXTERNAL TABLE impressions (
    requestBeginTime string,
    -- ...
    sessionId string)
PARTITIONED BY (dt string)
ROW FORMAT  serde 'org.apache.hive.hcatalog.data.JsonSerDe'
LOCATION 's3://elasticmapreduce/samples/hive-ads/tables/impressions/' ;

MSCK REPAIR TABLE impressions;
```

query
```sql
SELECT dt,impressionid FROM impressions WHERE dt<'2009-04-12-14-00' and dt>='2009-04-12-13-00' ORDER BY dt DESC LIMIT 100
```

## Bucketing

特定のcolumnの値が同じレコードを一つのfileに書き込むこと。

## Tips 

* file sizeが小さい(128MB未満)の場合、overheadがかかる。(s3 file open, metadata fetch, file header,...)

## Query tuning

Prestoのtuning。

* ORDER BY
  * `LIMIT`を指定すると、全件loadが避けられる。
    
* JOIN
  * 大きいほうを左側に、小さいほうを右側に指定する。Prestoは右側で指定されたテーブルをworker nodeに送ることに由来して効くらしい。
  * 複数tableのcross joinが発生すると、この限りではないらしい。 
    
* GROUP BY
  * GROUP BYはcardinalityが高い順に書くとよい。
  * 対象を文字列ではなく数字にできるとbetter  

* 近似関数
  * `SELECT COUNT(distinct user_id) FROM items` 2.3％の標準誤差を許容できるなら  
    `SELECT approx_distinct(user_id) FROM items`

* SELECTで`*`使わない

## Workgroups

* IAMが紐づく単位
* Cost, Limitが紐づく単位

## 参考

* [performance tips](https://aws.amazon.com/jp/blogs/news/top-10-performance-tuning-tips-for-amazon-athena/)
* [partition projection](https://aws.amazon.com/blogs/big-data/speed-up-your-amazon-athena-queries-using-partition-projection/)

## 確認事項

* `MSCK REPAIR TABLE` コマンドは新しいpartitionができたら毎回実行する必要がある? => 必要がある


## DynamoDB exportを分析する

DynamoDBの`ExportTablePointInTime` APIの結果をathenaから分析する。  
exportされたfileには以下のjsonが複数格納されているとする。  
```json
{
  "Item": {
    "UserID": {
      "N": "10"
    },
    "UserName": {
      "S": "ymgyt"
    }
  }
}
```

DDLは以下のようになる

```text
CREATE EXTERNAL TABLE IF NOT EXISTS xxx_table (
  Item struct <
    UserID:struct<N:string>,
    UserName:struct<S:string>>
)
PARTITIONED BY (year STRING, month STRING)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://export-table/prefix
TBLPROPERTIES ( 'has_encrypted_data'='false')
;
```

query

```sql
SELECT
 item.userid.n as user_id,
 item.username.s as user_name
FROM xxx_table
WHERE year = '2021' AND month = '7'
LIMIT 10
;
```



