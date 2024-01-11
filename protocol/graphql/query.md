# GraphQL Query

## Example

```
query { 
    me {
        name
    } 
}
```

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

```
{
  "data": {
    "books": [
      {
        "title": "City of Glass"
      },
      ...
    ],
    "authors": [
      {
        "name": "Paul Auster"
      },
      ...
    ]
  }
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

{
    "id": "abc",
    "format": {
        "displayCents": true,
        "currency": "USD"
    }
}
```

* `FetchProduct`はqueryの名前。(schemaにはない?)
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
