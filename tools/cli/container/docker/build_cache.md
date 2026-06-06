# docker build cache

* Dockerfileのinstruction(`RUN`,`COPY`)はlayerになる
* layerは変更がなければcacheされる
  * `RUN` 実行コマンド
  * `ADD`, `COPY`, `RUN --mount=type=bind`はfileからcacheを計算する
* A <- B <- C でBがinvalidateされたら、Cもinvalidteされる

## mount

### `--mount=type=bind`

hostのfsをmountする
defaultはread only

```sh
RUN  --mount=type=bind,target=/build \
    cargo build --release
```

* `target` mount path
  * `dst`,`destination`はalias
* `source`
* `from` build stageを指定できる
* `rw`

### `--mount=type=cache`

```sh
RUN  --mount=type=cache,target=/usr/local/cargo/registry,sharing=locked \
    cargo build --release
```

* `id`
* `target` mount path
  *`dst`, `destination` alias
* `sharing` `shared`, `private`, `locked`
  * package managerの期待にあわせる
* `ro` read only

### `--mount=type=secret`

```sh

RUN --mount=type=secret,id=git-credentials,dst=/root/.git-credentials \
    cargo build --release
```

## RUN instructions

```docker
FROM alpine:3.21 AS install
RUN apk add curl
```

* 毎回最新のcurlがinstallされるとは限らない


## Build secrets

* secretが変わっても、cacheをinvalidateしないので注意


## External cache

* CI/CD ではbuilderのcacheはrun(workflow)を跨いで保持されない
* `--cache-to`, `--cache-from`でcacheを外部に保持できる
