# Relay connection

```rust
#[Object]
impl Subscription {
    async fn feeds(
        &self,
        ctx: &Context<'_>,
        after: Option<String>,
        #[graphql(default = 20)] first: Option<i32>,
    ) -> Result<Connection<String, object::Feed>> {
        let first = first.unwrap_or(10) as usize;
        let has_prev = after.is_some();
        let input = FetchSubscribedFeedsInput {
            after,
            first: first + 1,
        };
        let Output {
            output: FetchSubscribedFeedsOutput { feeds },
        } = run_usecase!(FetchSubscribedFeeds, ctx, input)?;

        let has_next = feeds.len() > first;
        let mut connection = Connection::new(has_prev, has_next);

        let edges = feeds
            .into_iter()
            .map(|feed| (feed.url().to_owned(), feed))
            .map(|(cursor, feed)| (cursor, object::Feed::from(feed)))
            .map(|(cursor, feed)| Edge::new(cursor, feed));

        connection.edges.extend(edges);

        Ok(connection)
    }
}
```

* Relayのconnectionが素直にgenericになっている
  * Edgeのcursorもgenericになっている
  * Nodeの`T`にgenericになっている
* UserはConnectionを生成して、egesにextendする
  * pageInfoが必須なので、前,次があるかの情報を渡す

* `async_graphql::connection::query()`を利用することもできる
  * firstとlastの同時利用をチェックしてくれる
  * after,lastはgraphqlとしてはStringだが、userの型に変換もして渡してくれる
