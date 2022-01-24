# kill

## Send Signal
```shell
kill -s <signal>   <pid>
kill -s <signalID> <pid>
kill -<signalID>   <pid>
kill -<SIG>        <pid>
kill -SIG<signal>  <pid>
kill               <pid> # => pidを停止
```

* defaultでは `SIGTERM`
* `Ctrl` + `c`は `SIGINT`


## よく利用されるSignal

| Name | ID   | Description |
| ---- | ---- | ----        |
|EXIT|   0	|終了時にかならず送られる.|
|HUP|	1	|端末が制御不能/切断による終了|
|INT|	2	|キーボードからの割り込み(Ctr + C)|
|QUIT|	3	|キーボードによる中止(Ctr + /), coredump|
|KILL|	9	|強制終了(handlingできない)|
|TERM|	15	|終了(指定しないとこれ)|
|CONT|	18	|停止しているプロセスの再開|
|STOP|	19	|一時停止|


## kill -0

> If sig is 0, then no signal is sent, but error checking is still performed.

実際にはシグナルは送らないが、permission的にsignalがおくれるかをテストするために利用できる.
アルファベットO(オー)ではなく数字のゼロ

```shell
sudo sleep 2500 &

pgrep -f sleep
# => 25772

kill -0 $(pgrep -f sleep)
# => kill: kill 25772 failed: operation not permitted

sudo kill -0 $(pgrep -f sleep)
```


capistranoのdeploy時にも利用されている

```shell
[ -e /usr/xxx/app/shared/tmp/pids/unicorn.pid ] && \
kill -0 `cat /usr/xxx/app/shared/tmp/pids/unicorn.pid`
```

* signalID 0のシグナルは死活監視に利用できる
