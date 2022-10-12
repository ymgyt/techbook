# docker

## Build and Push

* docker imageを生成して、docker hubに公開する。

```console
docker build --tag ymgyt/xxx:0.1.0 .

docker push ymgyt/xxx:0.1.0

# latestのaliasをつける
docker image tag ymgyt/xxx:0.1.0 ymgyt/xxx:latest
docker image push ymgyt/xxx:latest
```

## Run

```console
docker run --rm -v $(pwd):/container/workingdir ymgyt/plantuml:latest example.puml
```

image名以降の引数はDockerfileのCMDとして、ENTRYPOINTの引数になる。

## Tagging

* localで生成したimageを別のrepositoryにpushするために必要

```shell
 docker tag ymgyt/tinypod:0.1.0 111122223333.dkr.ecr.ap-northeast-1.amazonaws.com/reponame:0.1.0
 
 # repositoryにpush
 docker image push 111122223333.dkr.ecr.ap-northeast-1.amazonaws.com/reponame:0.1.0
```

## Volume

### 不要なvolumeの削除

```shell
docker volume prune
```

* docker-composeで毎回volumeが作成されるらしい?

## Build

* build時にsshを利用する
  * private repositoryをfetchする等sshする場合
  * ssh-addでssh-agentに鍵が登録されている前提

```shell
docker image build --ssh default=${SSH_AUTH_SOCK}
```
