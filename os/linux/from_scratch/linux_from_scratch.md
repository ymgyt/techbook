# Linux From Scratch

Version 12.4-systemd


## Prerequisites

* Software-Building-HOWTO https://tldp.org/HOWTO/Software-Building-HOWTO.html

* Beginner's Guide to Installing from Source https://moi.vonos.net/linux/beginners-installing-from-source/ 

## Configure VM

```nu
let vbox_base = ([$env.HOME, "VirtualBoxVMs"] | path join)
let vm_name = "debian13-lfs"
let vm_base = ([$vbox_base, $vm_name] | path join)
let root_disk = ([$vm_base, "debian-root.vdi"] | path join)
let lfs_disk = ([$vm_base, "lfs-disk.vdi"] | path join)
let iso = "/home/ymgyt/iso/debian-13.2.0-amd64-netinst.iso"
let host_if = "wlp0s20f3"

# Create VM
VBoxManage createvm --name $vm_name --ostype Debian13_64  --register --basefolder $vbox_base

# Configure VM
VBoxManage modifyvm $vm_name --memory 8129 --cpus 8 --firmware bios --rtc-use-utc on --audio-driver none --usb-xhci off

# Create disk
VBoxManage createmedium disk --filename $root_disk --size 20480 --format VDI
VBoxManage createmedium disk --filename $lfs_disk --size 81920 --format VDI

# Add SATA controller
VBoxManage storagectl $vm_name --name "SATA" --add sata --controller IntelAHCI --portcount 3 --hostiocache on

# Attach disks
VBoxManage storageattach $vm_name --storagectl "SATA" --port 0 --device 0 --type hdd --medium $root_disk
VBoxManage storageattach $vm_name --storagectl "SATA" --port 1 --device 0 --type hdd --medium $lfs_disk
VBoxManage storageattach $vm_name --storagectl "SATA" --port 2 --device 0 --type dvddrive --medium $iso

# Modify boot order
VBoxManage modifyvm $vm_name --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Configure network
VBoxManage modifyvm $vm_name --nic1 bridged --bridgeadapter1 $host_if

# Start VM
VBoxManage startvm $vm_name --type gui
```

## Memo

```sh
# shがbashである必要がある
# sudo DEBIAN_FRONTEND=dialog dpkg-reconfigure dash
rm /bin/sh
ln -s bash /bin/sh
```

```sh
sudo apt update
sudo apt install -y gawk texinfo

# partitionを作成
sudo cfdisk /dev/sdb

> Select label type
gpt

> New
> Size: Enter
> Write -> YES
> Quit

# filesystemをformat
sudo /usr/sbin/mkfs -v -t ext4 /dev/sdb1

su -
export LFS=/mnt/lfs

# filesystemに登録
mkdir -pv $LFS
mount -v -t ext4 /dev/sdb1 $LFS

# configure permission
chown root:root $LFS
chmod 755 $LFS

# mountを永続化させる場合は/etc/fstabに追記する
# /dev/sdb1  /mnt/lfs ext4   defaults      1     1

# src領域を作成
mkdir -v $LFS/sources
# stickyを付与して共有領域として安全にする
chmod -v a+wt $LFS/sources

# https://lfsbookja.github.io/lfsbookja-doc/git-sysdja/wget-list-systemd をwget-list-systemdとして保存する
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources

# https://lfsbookja.github.io/lfsbookja-doc/git-sysdja/md5sums を md5sumsとして取得して
# 入手したpackagesをチェック
pushd $LFS/sources
  md5sum -c md5sums
popd
```


## LFS and Standards

* [POSIX.1-2008](https://pubs.opengroup.org/onlinepubs/9699919799/)
* [Filesystem Hierarchy Standard(FHS) Version 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
* [Linux Standard Base(LSB) Version 5.0](https://refspecs.linuxfoundation.org/lsb.shtml)
