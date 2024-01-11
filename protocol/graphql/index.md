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

## Operation

```graphql
query OperationName {
  foo() {
    selector
  },
  bar() {
    selector
  }
}
```

* queryやmutationをwrapするlayerとしてoperationがある
* Operationの中に複数のqueryやmutationが含まれる関係にある
  * 省略もできるが、productionでは明示したほうがよい


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

## API設計

### Mutationのresponseとして何を返すべきか

* GraphQLのspecとしては決まっていないらしい
* Responseとしてmutation適用後のobjectを返すapproch
  * frameworkのcache機構と相性がよい
  * clientはmutation後に再度queryを実施しなくてよい

* 以下のようにinputとoutputに1-to-1対応するapprochもある

```
type RootMutation {
  createTodo(input: CreateTodoInput!): CreateTodoPayload
  toggleTodoCompleted(input: ToggleTodoCompletedInput!): ToggleTodoCompletedPayload
  updateTodoText(input: UpdateTodoTextInput!): UpdateTodoTextPayload
  completeAllTodos(input: CompleteAllTodosInput!): CompleteAllTodosPayload
}
```

#### MutationResponse interface

```
interface MutationResponse {
  code: String!
  success: Boolean!
  message: String!
}

type UpdateUserEmailMutationResponse implements MutationResponse {
  code: String!
  success: Boolean!
  message: String!
  user: User
}
```

* まずすべてのmutation responseに共通するinterfaceをきる
* それから各mutationごとのresponseを追加する
* clientに一貫したresponse handlingを提供できる

#### Success Error union Response type

```
interface MutationResponse {
  status: ResponseStatus!
}

type CheckoutSuccess implements MutationResponse {
  status: ResponseStatus!
  cart: [Product!]!
  invoice: Invoice!
}

interface ErrorResponse {
  status: ResponseStatus!
  message: String!
}

type CheckoutError implements ErrorResponse {
  status: ResponseStatus!
  message: String!
}

union CheckoutResponse = CheckoutSuccess | CheckoutError

type Mutation {
  checkout(cart: ID!): CheckoutResponse!
}
```

* MutationResponse(Success)とErrorResponseのinterfaceをきる
* XxxResponseをSuccessとErrorのunionで表現する
