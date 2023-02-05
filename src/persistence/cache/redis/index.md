# Redis

## install

### cli

```shell
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make

# optional
make test

# put src to PATH
# make install
cp src/redis-server /usr/local/bin/
cp src/redis-cli /usr/local/bin/
```

### script

```shell
#!/bin/bash

VERSION=stable
SRC=redis-${VERSION}
ARCHIVE=${SRC}.tar.gz

function install() {
curl -O http://download.redis.io/releases/${ARCHIVE}
tar xzvf ${ARCHIVE}
cd ${SRC}
make
make test
make install
}

function clean() {
rm ${ARCHIVE}
}

install && clean
```

## Pipelining

複数のコマンドをserverに送信したいときに一つ一つのコマンドのレスポンスを待つのではなく、まとめて複数の
コマンドを送信する。

これを
```
Client: INCR X
Server: 1
Client: INCR X
Server: 2
Client: INCR X
Server: 3
Client: INCR X
Server: 4
```

こうする
```
Client: INCR X
Client: INCR X
Client: INCR X
Client: INCR X
Server: 1
Server: 2
Server: 3
Server: 4
```

### メリット

* RTT(Round Trim Time)が一回分にできること。
* read/write systemcallの回数が減らせる。

### デメリット

複数コマンドはserver側のメモリのqueueingされるので、適切な量を制御する必要性がでてくる。
