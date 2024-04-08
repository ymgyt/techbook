# LogQL

```
# ここでlabelによるfileterを行う
{job="syndicationd/synd-api"} 

# formatがjsonなのでjsonをparseする
| json

# jsonのkey valueをlabelとして検索できる
| attributes_operation = "Foo"
```

* `{key=value}`: 最初にlokiのlabelでlog streamを特定する
* `json`: logのformatがjsonの場合、parseできる
  * これによって、label以外もkey=valueによるfilterlingができる
  * `{ "user": { "name": "ymgyt" }}`の場合、`user_name = "ymgyt"`で検索できる


## Recipe

jsonの中のjson fieldをparseしたい  

```json
{
  "body": "{ \"key\": 100 }"
}
```

```logql
{k8s_namespace_name="foo", k8s_container_name="graphql"} 
| json 
| line_format "{{.body}}" 
| json 
| key = value
```

* `json`でparseした後に`line_format`で書き出して、さらにjsonでparseする
