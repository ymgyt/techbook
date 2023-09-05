# Either

matchやif等の分岐で、io::Write型が欲しいが、stdoutかfileで型が異なるということがよくある。  
その際に、`Box<dyn Write>`のようなtrait objectを利用してもよいが、2種類程度ならEitherで型づけできる。


```rust
let writer = match out {
    Some(path) => Either::Left(
        tokio::fs::File::create(path.as_std_path())
            .await
            .with_context(|| format!("Open {path}"))?
            .into_std()
            .await,
    ),
    None => Either::Right(std::io::stdout()),
};
```

 * `Either<File,Stdout>`型になる
  * `Either<L,R>`で、LとRがWriteならEitherもWriteになる