# Schema Definition Language

## Example

```graphql
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
    # Defaultを指定できる
    shop(id: ID, sort: SortOrder = DESC): Shop!
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

### Enums

```graphql
enum ShopType {
    APPAREL
    FOOD
}
```

### Interface

```graphql
# interfaceを定義
interace Discountable {
    priceWithDiscounts: Price!
}

# 具体型に実装
type Product implements Discountable {
    name: String!
    priceWithDiscounts: Price!
}

type GiftCard implements Discountable {
    code: String!
    priceWithDiscounts: Price!
}

# interfaceを返せる
type Cart {
    disbountedItems: [Discountable!]!
}
```

```graphql
query {
    cart {
        discountedItems {
            priceWithDiscounts
            ... on Product {
                name
            }
            ... on GiftCard {
                code
            }
        }
    }
}
```

* interfaceにないfieldはfragment spreadsで具体型を指定する必要がある


### Union

```graphql
union CartItem = Product | GiftCard

type Cart {
    items: [CartItem]
}
```

```graphql
query {
    cart {
        items {
            ... on Product {
                name
            }
            ... on GiftCard {
                code
            }
        }
    }
}
```

## Fragments

```graphql
query {
    products(first: 100) {
        ...ProductFragment
    }
}

fragment ProductFragment on Product {
    name
    price
    variants
}
```

* graphqlでは型を取得ができず、かならずfield levelまで指定することが求められる
  * これの再利用の単位
