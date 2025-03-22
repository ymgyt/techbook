# BPF maps

* kernelにloadされたbpf programとuser spaceのprogramが通信するためのきこう
* `include/linux/uapi/bpf.h`の`enum bpf_map_type`に定義されている
* userspaceからは`bpf` syscallでcreate/update等の操作を行う
* HashMap
  * keyとvalueの型はmap typeで決まる


## HashMap

普通のHashMap

## Array Map

* Array
* elementsはzero initialized

## Per-CPU Hash Map

* cpuごとに独立したmapを保持する
* lockが不要になるから速い?

## Per-CPU Array Map

* Array Mapのper cpu版

## Perf Event Array Map

* perf_eventsのdataをring bufferに保持する

## Stack

## Queue

## LPM Trie

* Longest Prefix Match Trie

## Socket Map/Hash

* kernelがopenしているsocket格納用

## Program Array Map

* bpf_tail_callと一緒に使う

## 参考

- [Oracle Linux Blog: BPF In Depth: Communicating with Userspace](https://blogs.oracle.com/linux/post/bpf-in-depth-communicating-with-userspace)


## PerfBuf vs RingBuf

* PerfBuf
  * cpuごとにあるcircular buffer

* RingBuf
  * linux 5.8から導入
  * Multi producer single consumer(MPSC) queue
  * PerfBufの課題をいろいろ解決しているらしい

