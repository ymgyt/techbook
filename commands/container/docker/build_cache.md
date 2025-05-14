# docker build cache

* Dockerfileのinstruction(`RUN`,`COPY`)はlayerになる
* layerは変更がなければcacheされる
  * `RUN` 実行コマンド
  * `ADD`, `COPY`, `RUN --mount=type=bind`はfileからcacheを計算する
* A <- B <- C でBがinvalidateされたら、Cもinvalidteされる


## RUN instructions

```docker
FROM alpine:3.21 AS install
RUN apk add curl
```

* 毎回最新のcurlがinstallされるとは限らない


## Build secrets

* secretが変わっても、cacheをinvalidateしないので注意


## Rust

```dockerfile
RUN --mount=type=cache,target=/app/target/ \
    --mount=type=cache,target=/usr/local/cargo/git/db \
    --mount=type=cache,target=/usr/local/cargo/registry/ \
    cargo build
```

## External cache

* CI/CD ではbuilderのcacheはrun(workflow)を跨いで保持されない
* `--cache-to`, `--cache-from`でcacheを外部に保持できる
