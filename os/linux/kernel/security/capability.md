# Capability

* PID 0のrootの権限を分割して付与できるようにする機能。  
  * Port 1080以下のbindにはrootが必要だが、そのためだけにroot与えるのはやりすぎなので、1080以下のport bind権限に切り出して与えられる様になる
* 付与の単位はthread。  
* `/usr/include/linux/capability.h`に定義されている
* `man capabilities`

## Threadのcapability

4種類のcapability setをもっている。  
実装的にはbit列で、capabilityをもっていれば1がセットされる。gg
cs=capability set

* permitted: effectiveとinheritableでもつことが許されるcs
* inheritable: execveした際に継承できるcs
* effective: kernelがthreadの実行権限を判定する際に使うcs
* ambient: 特権のない(seduid/setgidされていない) プログラムをexecveした際に子processに継承されるcs

capabilityが変化する機会

* `capset`: systemcallでcsを設定
* `execve`: systemcall前後でcsが変化
* `prctl`: systemcallでambientやbounding setを設定

### 実行中のprocessのcapabilityの確認

`/proc/<PID>/status`をみる

```sh
$ grep Cap /proc/1/status
CapInh: 0000000000000000
CapPrm: 0000003fffffffff
CapEff: 0000003fffffffff
CapBnd: 0000003fffffffff
CapAmb: 0000000000000000
```

`getpcaps <PID>`

### Capability bounding set


## File capability

fileにもcapabilityを設定できる
fileにもcapability setがある。

* permitted
* inheritable
* effective: 0 or 1

## 参考

* https://nojima.hatenablog.com/entry/2016/12/03/000000
  * ambientの話がよかった
