# N+1 query

## 問題

以下のqueryにおいて

```graphql
query {
  todos {
    users {
      name
    }
  }
}
```

1. TODOを複数取得
2. TODO毎にuserの取得を行う

という実装の場合

```text
SELECT id, todo, user_id FROM todo
SELECT name FROM user WHERE id = $1
SELECT name FROM user WHERE id = $1
SELECT name FROM user WHERE id = $1
// ...
```

というように1つのTODOsの取得とN(TODOs)のuser取得が実行されてします。
あるべきとしては

```text
SELECT id, todo, user_id FROM todo
SELECT name FROM user WHERE id IN (1, 2, 3, 4)
```

としたい。

## dataloader

`async_graphql::dataloader::DataLoader`を利用する

```rust
use async_graphql::*;
use async_graphql::dataloader::*;
use std::sync::Arc;

struct UserNameLoader {
    pool: sqlx::PgPool,
}

#[async_trait::async_trait]
impl Loader<u64> for UserNameLoader {
    type Value = String;
    type Error = Arc<sqlx::Error>;

    async fn load(&self, keys: &[u64]) -> Result<HashMap<u64, Self::Value>, Self::Error> {
        Ok(sqlx::query_as("SELECT name FROM user WHERE id = ANY($1)")
            .bind(keys)
            .fetch(&self.pool)
            .map_ok(|name: String| name)
            .map_err(Arc::new)
            .try_collect().await?)
    }
}

#[derive(SimpleObject)]
#[graphql(complex)]
struct User {
    id: u64,
}

#[ComplexObject]
impl User {
    async fn name(&self, ctx: &Context<'_>) -> Result<String> {
        let loader = ctx.data_unchecked::<DataLoader<UserNameLoader>>();
        let name: Option<String> = loader.load_one(self.id).await?;
        name.ok_or_else(|| "Not found".into())
    }
}
```

* [Book Optimizing N+1 queries](https://async-graphql.github.io/async-graphql/en/dataloader.html)