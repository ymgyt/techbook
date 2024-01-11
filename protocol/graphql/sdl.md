# Schema Definition Language

## Example

```
type Shop {
    name: String!
    # Where the shop is located, null if online only. location: Location
    products: [Product!]!
}

type Location {
    address: String
}

type Product {
    name: String!
    price: Price!
}

type Query {
    shop(id: ID): Shop!
}
```

```
 type Query {
  shop(owner: String!, name: String!, location: Location): Shop!
}
```

## Types

GraphQL definitionのtypeは以下のいずれかに分類できる

* Scalar
* Object
  * Query, Mutation, Subscriptionも含まれる
* Input
* Enum
* Union
* Interface

### Object

* 自動で`__typename` fieldが追加される
  * unionやinterface型から具体型を判別したりもできる


### Input

* fieldにscalar,enum, other inputしか使えない