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
