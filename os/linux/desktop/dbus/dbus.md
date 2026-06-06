# D-Bus

* 実装はunix domain socket
* bus 実装として dbus-daemon, dbus-brokerがあるらしい

## IPCの流れ

client process -(uds)-> bus process -(uds)-> server process

## IPCの概要

* 以下の要素を特定して通信する
  * bus name
    * service名
  * object path
  * interface
  * member(method, signal, property)
