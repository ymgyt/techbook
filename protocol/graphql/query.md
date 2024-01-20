# GraphQL Query

## Example


```
query GetBooksAndAuthors {
  books {
    title
  }

  authors {
    name
  }
}
```

* `query`と`Operation name(GEtBooksAndAuthors)は省略できる

```
query { 
    me {
        name
        friends(first: 2) {
            name
            age
        } 
    }
}
```

```
# これも有効
{
  shop(id: 1) {
    name 
}
```

## Variables

sdl
```
type Product {
    price(format: PriceFormat): Int!
}

input PriceFormat {
    displayCents: Boolean!
    currency: String!
}
```

query
```
query FetchProduct($id: ID!, $format: PriceFormat!) {
    product(id: $id) {
        price(format: $format) {
            name
        } 
    }
}

# variable
{
    "id": "abc",
    "format": {
        "displayCents": true,
        "currency": "USD"
    }
}
```

* `FetchProduct`はqueryの名前。
* この例だとnameがどこから出てきたのか不明

## Alias

```graphql
query {
    abcProduct: product(id: "abc") {
        name
        price
    } 
}
```
response

```
{
    "data": {
        "abcProduct": {
            "name": "T-Shirt",
            "price": 10,
        } 
    }
}
```

## Unionに対するquery

* responseの型が`type Response = SubscribeFeedSuccess | SubscribeFeedError`のようにunionになっている場合、selectorをかき分ける
* `__typename`はtoolが要求したから書いた

```graphql
mutation SubscribeFeed($input: SubscribeFeedInput!) {
  subscribeFeed(input: $input) {
    __typename
    ... on SubscribeFeedSuccess {
      url
      status {
        code
      }
    }
    ... on SubscribeFeedError {
      status {
        code
      }
    }
  }
}
```
