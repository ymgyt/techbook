# Elasticsearch

## 用語

* document
  * 複数のfieldをもつ検索単位
* index
  * documentの格納単位。DBでいうtable
* mapping
  * documentのfiledのdata構造, schema?


## index template

patternに該当するindexが作成される際に事前に定義したmappingを適用する仕組み。  
例えば`accesslog-2022.11.8`といったdailyのlog indexに対するtemplateは以下のように定義できる

```text
PUT _template/my_template
{
    "index_patterns": "accesslog-*",
    "settings": {
        "number_of_shards": 1
    },
    "mappings": {
        "properties": {
            "host": { "type": "keyword" },
            "uri": { "type": "keyword" }
        }
    }
}
```

* 複数のtemplateを適用することができる
  * `order`が低い順に適用され、`order`が高い設定で上書きされる
  * `index_patterns: "*"`とするとdefault設定が定義できる感じ

## data stream

* aliasのようにclientからstreamにdataを書き込むと対応するindexに書き込まれる
* aliasと違うのは、time serise data(append only, no update)に適している
* rolloutという書き込まれるindexを置き換える概念がある
  * sizeや時間で指定できる
  * rolloutすると、別のphaseに移行する

## `docker-compose`

```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.5.2
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    healthcheck:
      test: [ "CMD-SHELL", "curl -sSL http://localhost:9200/_cluster/health | grep -vq '\"status\":\"red\"'" ]
      retries: 12
      interval: 5s
    ports:
      - "9200:9200"
```

* `9200`はREST api port
