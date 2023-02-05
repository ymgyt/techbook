# MAC address

media access control address.  
network interface controllerに割り振られるunique identifier.  
*48bit*で構成される。

## bit構成

* 0-23bit: vendorID
* 24-31bit: 機種ID
* 32-47bit: シリアルID

## unicast / multicast

先頭byteの1bit目が
* 0: unicast
* 1: multicast

[参考 wikipedia](https://en.wikipedia.org/wiki/MAC_address#/media/File:MAC-48_Address.svg)
