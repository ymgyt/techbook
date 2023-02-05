# Elasticsearch REST Api

* `GET`では`?pretty` queryをつけるとみやすくなる。
  * kibanaは自動で付与してくれていそう

## Cluster

* `GET /_cluster/health` 
  * clusterの情報を取得する

```json
{
  "cluster_name": "docker-cluster",
  "status": "yellow",
  "timed_out": false,
  "number_of_nodes": 1,
  "number_of_data_nodes": 1,
  "active_primary_shards": 10,
  "active_shards": 10,
  "relocating_shards": 0,
  "initializing_shards": 0,
  "unassigned_shards": 2,
  "delayed_unassigned_shards": 0,
  "number_of_pending_tasks": 0,
  "number_of_in_flight_fetch": 0,
  "task_max_waiting_in_queue_millis": 0,
  "active_shards_percent_as_number": 83.33333333333334
}
```

## Index

### Index一覧の取得

```text
GET /_cat/indices[?format=json]
```

## Document

### Create

```text
POST /my_index/_doc
{
  "user_name": "Ymgyt",
  "data": "2022-12-09T20:36:00+09:00",
  "message": "Hello elasticsearch !"
}
```

```json
{
  "_index": "my_index",
  "_id": "1",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 0,
  "_primary_term": 1
}
```

* `my_index` indexが存在しない場合は作成してくれる

### Documentの取得

```text
GET /my_index/_doc/1
```

```json
{
  "_index": "my_index",
  "_id": "1",
  "_version": 1,
  "_seq_no": 0,
  "_primary_term": 1,
  "found": true,
  "_source": {
    "user_name": "Ymgyt",
    "data": "2022-12-09T20:36:00+09:00",
    "message": "Hello elasticsearch !"
  }
}
```

### Documentの検索

```text
GET /my_index/_search
{
  "query": {
    "match": {
      "message": "Hello"
    }
  }
}
```

* `POST`でも可能。(おそらくGETにbody付与できないclient用)
* 詳細なquery方法は[query](./query_dsl.md)参照。

#### 検索対象indexの指定

* `/my_index/_search`: `my_index`を検索
* `/my_index,my_index2/_search`: `my_index`,`my_index2`を検索
* `/my_index*`: `my_index`に前方一致するindexから検索
* `/_search`: すべてのindexから検索

## Mapping

```text
GET /my-index/_mapping
```

## Index template

```text
GET /_template
```
