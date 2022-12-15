# Query

* `/_search`のdsl

```text
GET /my_index/_search
```

```json
{
  "query":  {},
  "from": 0,
  "size": 10,
  "sort": [],
  "_source": []
}
```

* `query`
* `from/size`
  * pagination用。defaultは0から10件


## 全件取得

```json
{
  "query": {
    "match_all": {}
  }
}
```
