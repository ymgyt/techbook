# Rust

## Simple

```Dockerfile
FROM rust:1.57.0-slim-bullseye

COPY ./ ./

RUN cargo build --release

CMD ["./target/release/taskmanager"]
```

* 自分がわかっている範囲のBest Practice
* 100M切るくらいのimageになる

## Current Best Practice

```Dockerfile
FROM rust:1.57.0-slim-bullseye as builder

RUN USER=root cargo new --bin taskmanager
WORKDIR /taskmanager

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# dependenciesをlayerとして保持する
RUN cargo build --release
RUN rm src/*.rs

# 通常はここから再実行される
COPY ./src ./src

RUN rm ./target/release/deps/taskmanager*
RUN cargo build --release

# runtimeにrustはいらない
FROM debian:bullseye-slim

COPY --from=builder /taskmanager/target/release/taskmanager .

ENV RUST_LOG=info
CMD ["./taskmanager"]
```
