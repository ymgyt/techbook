# virio-fs

* guestにhostのfsをみせる仕組み(file共有)
* guestのfs driverでリクエストをFUSE protocolで virtqueueにのせる
* host側にvirtiofsdがいてFUSE requestを処理


## mount

```sh
mount -t virtiofs shared0 /mnt/shared
```

* `shared0` はvirtio-fs driverが知っているなんらかの識別子
