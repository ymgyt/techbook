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

### VM の登録

```sh
virsh define vm.xml
```

### VM の一覧

```sh
virsh list --all
```

### VM の起動

```sh
virsh start vm01
# 起動してconsoleに接続
virsh start vm01 --console
```

### VM の停止

```sh
virsh shutdown vm01

# 強制終了
virsh destroy vm01
```

### VM の登録解除

```sh
virsh undefine vm01 --nvram
virsh undefine vm01 --nvram --remove-all-storage
```

## Network

```sh
virsh net-dhcp-leases default
```

## Pool

```sh
# list
virsh pool-list --all
```

### Dir Pool

```sh
virsh pool-define-as vm01 dir --target path/to/dir
```


### Volume

```sh
# 一覧
virsh vol-list pool1

# 削除
virsh vol-delete volumen1 --pool pool1
```
