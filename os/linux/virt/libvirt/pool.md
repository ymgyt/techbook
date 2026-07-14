# Pool

* libvirtのstorage 管理object
* typeをもつ
* storage管理用のdirをわざわざpoolとして抽象化するのは、NFSとか他のstorage使っても同じ方法で扱いたいから

## Dir type

1 dirをvolume管理用としてlibvirtに登録したもの

## References

* [Storage Management](https://libvirt.org/storage.html)
