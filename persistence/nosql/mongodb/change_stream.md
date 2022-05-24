# Change Streams

* DynamoDB StreamのMongo版
* [Specification](https://github.com/mongodb/specifications/blob/master/source/change-streams/change-streams.rst#resumable-error)

## 前提条件

* WiredTiger storage engineを利用していること。
* replica set protocol version 1 (pv1)を利用していること。
* 4.2以前では、read concernがmajorityである必要があった。4.2からはこの制約はなくなった。


## Watch

change streamをopenできるリソースは以下。

* collection
  * system collections, admin,local,config databaseのcollectionは対象外
* database
  * databaseの全てのcollectionを対象にできる
* deployment
  * deployment(replica set or shared cluster)のdatabaseのcollection全てを対象にできる

## ChangeEvent

https://www.mongodb.com/docs/manual/reference/change-events/#change-events

* `operation_type`
  * insert
  * delete
  * replace
  * update
  * drop
  * rename
  * dropDatabase
  * invalidate

* `ns`
  * namespace. databaseとcollectionの情報をもつ。

* `to`
  * `operation_type: rename`以外ではNone.

* `document_key`
  * `_id`. documentの識別子。

* `cluster_time`
  * eventのoplog timestamp

* `full_document`
  * insert,replace時はnew document
  * delete時はomitted
  * update時はchange streamを`updateLookup`を設定した場合majority-committed versionのdocが入る
