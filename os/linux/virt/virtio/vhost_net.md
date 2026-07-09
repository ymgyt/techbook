# vhost_net

* host側のkernel module/driver
* guest virtio-net がnotify したあと、VM ExitでQEMUがqueueを処理するのではなく、vhost_netが直接処理する
* QEMUが `/dev/vhost-net` を open/ioctl で設定する、virtio-net backend module
* eventfd の仕組みを使い、vhost-netはeventfd を pollしている


## 流れ

guest virtio_net driver
→ TX virtqueue に descriptor を置く
→ virtio PCI notify register に write
→ KVM がその write を検出
→ QEMU が事前登録した eventfd を signal
→ host kernel の vhost_net worker が起きる
→ guest memory 上の virtqueue を読む
→ tap/socket に packet を流す
