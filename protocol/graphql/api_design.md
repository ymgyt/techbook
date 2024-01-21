# Api Design

* `User`のような抽象的な型をきらないほうがよい
  * nameだけを返すinterfaceにして、`TeamMember implements User`のように必要になるcontextに実装させる

* 検索系
  * 検索usecaseごとにqueryきってよい

```graphql
type Query {
  productByID(id: ID!): Product
  productByName(name: String!): Product
}
```


## Pagination vs Cursor

* Cursorはclientに対して現在より前/後の移動しか許可しない
  * 3 page目というような操作ができない
    * そもそも2page目を飛ばして3page目にいきたいusecaseはあるのか疑う 


## Global Identification 

```graphql
interface Node {
  id: ID!
}

type User implements Node {
  id: ID!
  name: String!
}
```

* これはRelayのpractice
  * 必ずしも実装する必要はない
  * Relay clientのcacheの都合
  * Apoloはtype nameとidでuniqueらしい

* IDはbase64 encodeしてclientにopaqueとしておく
  * slackのようにdeveloperへのhintとしてprefixくらいはつけてもよい
