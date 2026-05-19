# virtio

## 課題

* Guest OS(device)がMM I/O アクセスするたびに、VM-Exitしているとオーバーヘッドが大きい
  * VMX root <-> non-root
  * Device emulatorはuserspaceなのでそのスケジュール
  * NICの受信で5回のMM I/O が発生すると都度これが必要


## 概要

* Guest側であることを認識して、host側への通知(MM I/O) を減らす仕組み

* Guest Host でメモリ共有してring等に書くいつものやつ

* Guest OSにはPCI Deviceのようにみせている
  * virtio要のvendor,deviceをもっているので、virtio用のdriverがprobeされる
