# GraphQL

## memo

* QueryはPOSTのbodyに書く



## Query

```console
curl  'http://snowtooth.herokuapp.com/'
  -H 'Content-Type: application/json'
  --data '{"query":"{ allLifts {name }}"}'
```

## Tools

* https://www.graphqlbin.com/v2/new
* https://docs.github.com/en/graphql/overview/explorer


## Request

HTTP的にはどういうrequestを作ればよいか。

```json
{
  "query": "query GreetingQuery ($arg1: String) { hello (name: $arg1) { value } }",
  "operationName": "GreetingQuery",
  "variables": { "arg1": "Timothy" }
}
```

* `query`,`operationName`, `variables`のfieldをもつjsonをbodyにいれる
* Http Headerは実装次第?
  * `content-type: application/json` いる?
* Methodも実装次第。普通は`POST` ?


