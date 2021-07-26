# DynamoDB

## Secondary Index

紐づくtableは一つで、indexの文脈ではbase tableといわれる。

### Global Secondary Indexes(GSI)

* base tableとは異なるpartition keyとsort keyをもてる。  
* local secondary indexとの対比でglobalといわれる、要は制約がない。
* tableとは独立してCreate/Deleteできる
* eventual consistencyのみサポート
* base tableとは別にCUをもつ
  * GSIへのQuery時にRCU超えたらエラーになる。
  * base tableの書き込み時に、GSIのWCU超えたら、writeが失敗する  
* indexにprojectedされたattributeしかquery/scanできない
* base table key attributes(primary,sort)は必ずprojectedされる
* indexのkey attributesがbase tableにinsertされたitemに存在しない場合は、index側に反映されない。
  * この性質を利用して、GSIのprimary keyをbase tableのフラグ的な情報にしておくと、GSIのitem数を低く抑えられる。

#### Projection

indexにbase tableの情報をどの程度保持できるか制御できる。  
Queryの要件で決まる。

* `KEYS_ONLY` : base tableのkey attributesのみ。もっともindexを小さく保てる。
* `INCLUDE`   : `KEYS_ONLY`に加えて、追加のattributeを指定できる。
* `ALL`       : baseのすべてのattributesをprojectする。もっとも汎用的だが、indexが大きくなる。


#### Synchronization

base tableが更新されると自動でGSIが非同期で更新される。applicationは直接GSIに対してwriteできない。  
**GSIへのqueryの結果がbase tableに存在しないことは起きうるので、applicationはこれを前提にしておく**


### Local Secondary index(LSI)

* base tableと同じ、partition keyをもつが、sort keyが異なる。  
* 1 partition key valueに対して10 GBの制限がある。
* table作成時にcreateする必要がある。
* strong consistencyもサポート。
* base table側のCUを消費する
* indexにscanされていないattributeでもbase tableからdynamoが自動でfetchしてくれる


## Capacity Unit

Autoscaleの設定で1秒ごとのRead Capacity Unit(RCU), Write Capacity Unit(WCU)を設定する。  
CUはDynamoDBへのAPIによって消費される。  
実際に消費されるCUはAPIのOperationごとに異なる。

ベースになるのはAWS(Dynamo)のメモリにのったitemのbyte数。byte数を表示してくれるサイト等があるのでそこで図っておくと目安になる。

### Read

defaultのeventually-consistentの場合、1RCUで8KBまでのitemを扱える。

## Best Practices

[公式のBest Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html) まとめ

* table設計の時点からUse caseのQueryを念頭においた設計が求められる。
  * 検索条件を特定して、Primary key, GSIを作成しておく必要があるから。
    
## PITR

* Point In Time Recovery。偶発的なデータ消失に対する追加の保険として機能する。
* パフォーマンスに影響しない
* PITR APIはCloudTrailに記録される
* Costはstorage size単位(Tokyo region 1G 10円)
    
## Export

* 過去35日間、1秒あたりの粒度で任意のポイントインタイム
* RCUに影響しない


## 参考

[How to Calculate a DynamoDB Item's Size and Consumed Capacity](https://zaccharles.medium.com/calculating-a-dynamodb-items-size-and-consumed-capacity-d1728942eb7c)
