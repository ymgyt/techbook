# apt

## apt-get

* `apt-get install --assume-yes --quiet --no-install-recommends`
  * これがscript(docker file)とかでオススメ
* `/var/lib/apt/lists/*`にpackageのcacheが残るので、Dockerfileでは消しておく

### `apt-get clean`

* `/var/cache/apt` 以下を削除する
* dockerfile等では、`/etc/apt/apt.conf.d/docker-clean`でいろいろ設定があり効果がない場合もある


## Usage

```shell
# update local repository
apt update
```

## Repository管理

* `deb [option] <url> <distribution> <component>`
  * `deb`は`.deb`のbinary packageを意味
    * `deb-src`がsrc用
  * `/etc/apt/sources.list`もしくは`/etc/apt/sources.list.d`配下に置く
  * aptは<url>/dist/<distribution>/<component>配下を探しに行く


example
```text
deb [signed-by=/usr/share/keyrings/llvm.gpg] https://apt.llvm.org/jammy/ llvm-toolchain-jammy-18 main
```
