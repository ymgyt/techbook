# CloudTrail Lake

* 既存のeventsをApache ORCに変換する
* Eventsはevent data storeにaggregateされる
* (最大?) 7年間(2557 days)保持できる
* management event, data eventが対象
* AWS以外とも統合できるらしい
* [Presto](https://prestodb.io/docs/current/functions.html)のQuery使える

