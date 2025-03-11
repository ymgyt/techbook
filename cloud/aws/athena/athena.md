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

## 料金

* Scanされた1TBあたり、5USD
  * MB単位で切り上げられ、10MB未満は10MBと計算される

## Database

tableの集合

```
CREATE DATABASE mydatabase
```
    

## SQL

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



