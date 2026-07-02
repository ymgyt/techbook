# virsh

```sh
 virsh --connect qemu:///system net-list --all

# 有効化
virsh --connect qemu:///system net-start default

# VMの表示?
virt-viewer vm01
```

* `--connect`
  * `LIBVIRT_DEFAULT_URI` で指定もできる


## VM Lifecycle

```sh
virsh start vm01

# 詳細の表示
virsh dumpxml vm01

# VMの表示?
virt-viewer vm01

# shutdown(graceful)
vm shutdown vm01

# 電源落とす(force)
virsh destroy vm01

# 削除
virsh undefine vm01 --remove-all-storage
```


## Network

```sh
virsh net-dhcp-leases default
```
