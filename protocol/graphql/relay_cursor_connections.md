# Relay Cursor Connections

* Connection
  * 複数resourceに対するmeta情報
    * next page, total count
* Edge
  * resourceにcursor fieldを追加したいのでwrapした型

## Step by step

```
{
  hero {
    name
    friends {
      name
    }
  }
}
```

これだとfriendsの全件取得となってしまう
そこで、何件欲しいかを表現できるようにする

```
{
  hero {
    name
    friends(first: 2) {
      name
    }
  }
}
```

しかしこれだと、100-105が欲しい場合、105件取得する必要がある
そこで、cursorを導入して、今取得しているobjectの情報を渡せるようにしたい。  しかし、cursorはmodelのfieldに追加したくないので、Edgeというlayerを導入する


```rust
struct Edge<T> {
  node: T,
  cursor: String // opaque base64 cursor
}
```

```
{
  hero {
    name
    friends(first: 2, after: "ABCD") {
      node {
        name
      }
      cursor
    }
  }
}
```

この情報で全件取得したい場合、requestを繰り返して空のresponseを取得する必要がある。 
そこで、Connection layerを導入して、全件の数や次があるかの情報を返せるようにする

```
{
  hero {
    name
    friends(first: 2, after: "ABCD") {
      totalCount
      edges {
        node {
          name
        }
      }
      pageInfo {
        endCursor
        hasNextPage
      }
    }
  }
}
```

## References

* [Relay Cursor Connectionsの仕様と実装方法について](https://wawoon.dev/posts/how-to-implement-relay-cursor-connection)
  * 非常にわかりやすかった
