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

```
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
