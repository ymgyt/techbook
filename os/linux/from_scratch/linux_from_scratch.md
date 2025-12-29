# Linux From Scratch

Version 12.4-systemd


## Prerequisites

* Software-Building-HOWTO https://tldp.org/HOWTO/Software-Building-HOWTO.html

* Beginner's Guide to Installing from Source https://moi.vonos.net/linux/beginners-installing-from-source/ 

## Memo

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
