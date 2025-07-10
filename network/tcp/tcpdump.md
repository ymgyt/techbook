# tcpdump

## Usage

```sh
# まずinterfaceを特定する
# 以降は ens3とする
ip addr


sudo tcpdump -i en3 -s 0 <expression>
```

* `-i`: network interfaceの指定
* `-s`: captureするpacket size. 0は全て
* `-n`: hostやportの名前解決をしない
* `-v`: verbose
* `-X`: packetの中身の表示
* `-c`: captureするpacketの数
* `-w`: 保存file名
  * `--print`: stdoutにも表示する(tee like)

* expression
  * `port 502`: portの指定
