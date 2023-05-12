# chrony

## Config file

`/etc/chrony.conf`

1行ずつdirectiveを書く

### Directive

#### 接続先NTP Serverの指定

`server hostname [option]`

* hostnameにはdomainやipを書ける

options

* `iburst`
  * 起動時の同期を早めてくれる。基本書いて良い

## Commands

### NTP Serverとの同期の確認

`chronyc sources -v`

```
 chronyc sources -v
210 Number of sources = 1

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^? xx-xxxxxxxxx-NTP.dhlg         0  10     0     -     +0ns[   +0ns] +/-    0ns
```

`-v`つけると表示の意味も教えてくれる


## Manual

* `man chronyc`
* `man chrony.conf`


## 設定の反映

`systemctl restart chronyd`