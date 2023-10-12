# cgroup

## 歴史

* kernelの2.6.24ではじめて導入された。これがcgroup v1
* 4.5でcgroup v2が導入

## 概要

* 機能としてのcgroupと、processををまとめた単位としての狭義のcgroupがある
* containerに限定された機能ではなく、通常のprocessに対しても用いられる

## cgroup v1とv2

* v1は汎用的に設計された。そのため制限したいリソースごとに設定が必要
* v2ではcontainerとsystemdのおかげで、cgroupの認知度があがった
* v1からv2への移行は硬いが、現在は過渡期


## cgroup filesystem

* cgroup filesystemという仮想的なfsをmountしている
  * 用はfile/directoryでcgroupを操作できるようにしてくれている
  * 内部的にはkernfsを使っている
  * `/sys/fs/cgroup`にmountされるのが慣習。systemdがそうしているから。