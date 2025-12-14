# Dockerfile

## syntax

fileの先頭に`syntax=docker/dockerfile:1`のように書く。  
* buildkitはDockerfileのparserを分離しており、ここで指定できる。
  * これにより新しい構文(RUN --mountとか)を利用できる
  * `# syntax=<remote image ref>`
* `# syntax=docker/dockerfile:1` がrecommend

## multi stage

build用のimageと実行環境のimageを分離できる. 実行環境にはruntimeしか必要ない

```text
# 1. Build image
FROM golang:1.8.4-jessie AS builder

# Install dependencies
WORKDIR /go/src/github.com/ymgyt/greet
RUN go get -d -v github.com/some/dependencies

# Build modules
COPY main.go .
RUN GOOS=linux go build -a -o greet .


# --------------------------------------

# 2. Production image
FROM busybox
WORKDIR /opt/greet/bin

# Deploy modules
COPY --from=builder /go/src/github.om/ymgyt/greet/ .
ENTRYPOINT ["./greet"]
```


### multi stage to inject CA Certs

```
FROM golang:alpine as build
RUN apk --no-cache add ca-certificates
WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 go build

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/bin/app /app
ENTRYPOINT ["/app"]
```


## Build Context

docker buildコマンドをうつと、curren working directoryはbuild contextと呼ばれるようになる。current directoryの全file/dirがDocker Daemonに送られる。
Daemonに送る必要がないfileは, `.dockerignore` に登録しておく(gitignoreと同じsyntax)

## FROM

base imageを指定する


## RUN

* `RUN apt-get install -y nginx` とするとDockerコンテナ内で `/bin/sh -c` でコマンド実行するのと同じことがおきる
* `RUN ["echo", "hello from docker"]` 引数をjson配列(EXEC方式)にするとshellをかえさないで実行される.
* `RUN ["/bin/bash", "-c", "echo", "hoge"]` とすると明示的にbashで実行できる
* `apt-get`には`--no-install-recommends`を付与するのがBP

```
RUN apt-get update \
    && apt-get install --assume-yes --quiet --no-install-recommends\
        fonts-takao \
        graphviz \
        wget
```

### heredocs

```dockerfile
RUN <<EOF
apt-get update
apt-get install --assume-yes --quiet --no-install-recommends ca-certificates
rm -rf /var/lib/apt/lists/*
EOF

```

### RUN --mount

[build_cache](./build_cache.md)参照

## CMD

RUNはimageを作成するためのcommandを記述するがCMDは生成されたcontainer内で実行するcommandを指定する.
DockerfileにはひとつのCMDしか指定できない、複数指定しても最後のものが有効になる.3通りに記述方法がある

### Exec form

`CMD ["nginx", "-g", "daemon off;"]`

### Shell form

`CMD nginx -g "daemon off";`


### 実行時にoverwrite

実行時にCMDの内容を上書きできる

```
FROM alpine:3.7
CMD ["uname"]
```

```
docker container run $(docker image build -q .) echo yay
```

### ENTRYPOINT or CMD

* ENTRYPOINT and CMD give you a way to identify which executable should be run when a contianer is started from your image
  * 特に, `docker run` command line argumentなしで imageをrunnnableにしたい場合は ENTRYPOINT と CMDの指定は MUST
  * userは has the option to override either of theses values at run time
* shell form, exec form
  * `ENTRYPOINT ["mycommand", "args"]` のように、arraryで記述する
  * `ENTRYPOINT mycommand args`と書くと、`bash -c` でwrapされ、PID 1はshellになる
    * shell はSignalを子プロセスにforwardしない
  * CMDも同じ
  * entrypoinst.sh のようにwrapしている場合はshell側で、`exec command`するようにする

```
FROM ubuntu:trusty
CMD ping localhost
```

として、tag "demo" でbuildしたあと、 `docker run -t demo` を起動すると pingコマンドが実行される

`docker run demo hostname` のように image nameのあとのargで上書きできる

ENTRYPOINTも overrideできるが, ``--entrypoint`` flagが必要になる

`docker run --entrypoint hostname demo`

ENTRYPOINT sends a strong message that this container is only intended to run this one command

#### Combine ENTRYPOINT and CMD

```
FROM ubuntu:trusty
ENTRYPOINT ["/bin/ping", "-c", "3"]
CMD ["localhost"]
```

When both an ENTRYPOINT and CMD are specified, the CMD string(s) will be appended to the ENTRYPOINT in order to generate the container's command string
ENTRYPOINTとCMDを併用する場合は常に exec formを利用すること

## ONBUILD

次のbuildで実行するcommandをimage内に設定するための命令.image AにONBUILDを書いてbuildする. image Bがimage AをFROMで利用するとimage Bのbuild時にONBUILDが実行される.


## WORKDIR

以下の命令のcwdを指定する.なければdir作ってくれる

* RUN
* CMD
* ENTRYPOINT
* COPY
* ADD


## USER

imageの実行や以下の命令を実行するuserを指定

* RUN
* CMD
* ENTRYPOINT

```
RUN ["adduser", "yuta"]
RUN ["whoami"] # => root
USER yuta
RUN ["whoami"] # => yuta
```

## RUN

### Enable host ssh

```
RUN --mount=type=ssh cargo build --release
```

* `docker image build --ssh default${SSH_AUTH_SOCK}`
  * ssh-addしてある前提で、host側のsshをdocker image build時に利用できる

### Install packages by apt-get

```dockerfile
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
```

* `apt-get update`と`apt-get install`は同一RUNに書く

```dockerfile
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y curl # nginx最初はなくてあとで追加
```

わけた書いた場合installするpackageを追加しても、`apt-get update`の結果はcacheされており、古いpackageが利用される場合があるから(cacheされたapt-get updateの結果も参照されないらしい)

## EXPORSE

Dockerに実行中のcontainerがlistenしているportを知らせる.


## ARG

Dockerfile内で利用する変数を定義.

```
ARG YOURNAME="default"
RUN echo $YOURNAME
```

`docker build . --build-arg YOURNAME="yuta"` とするとbuild時に値を変えられる

## ENV

環境変数の指定

```
ENV KEY "VALUE"

ENV KEY_1="VALUE_1" \
KEY_2="VALUE_2" \
KEY_3="VALUE_3"
```


`docker container run --env key=value` で上書きできる
