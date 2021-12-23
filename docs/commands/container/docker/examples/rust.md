# Rust

## Simple

```Dockerfile
FROM rust:1.57.0-slim-bullseye

COPY ./ ./

RUN cargo build --release

CMD ["./target/release/taskmanager"]
```
