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
