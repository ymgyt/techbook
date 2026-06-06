# async_graphql

## Default

```rust
use async_graphql::*;

struct Query;

fn my_default() -> i32 {
    30
}

#[Object]
impl Query {
    // The default value of the value parameter is 0, it will call i32::default()
    async fn test1(&self, #[graphql(default)] value: i32) -> i32 { todo!() }

    // The default value of the value parameter is 10
    async fn test2(&self, #[graphql(default = 10)] value: i32) -> i32 { todo!() }
    
    // The default value of the value parameter uses the return result of the my_default function, the value is 30.
    async fn test3(&self, #[graphql(default_with = "my_default()")] value: i32) -> i32 { todo!() }
}
```
