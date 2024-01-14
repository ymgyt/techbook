# TOML

## Table

```toml
[dog.foo]
a = "b"

# { "dog": { "foo": "a": "b" } }
```

* `[aaa.bbb]`にように書くとnest先のkey valueを指定できる
* これにより深い階層でもyamlのようにnestせずに表現できる

## Array of Table

```toml
[[products]]
name = "array of table"
sku = 738594937
emptyTableAreAllowed = true

[[products]]

[[products]]
name = "Nail"
sku = 284758393
color = "gray"
```

は

```json
{ 
  "products": [
    {
      "name": "array of table",
      "sku": 7385594937,
      "emptyTableAreAllowed": true
    },
    {},
    {
      "name": "Nail",
      "sku": 284758393,
      "color": "gray"
    }
  ]
}
```
