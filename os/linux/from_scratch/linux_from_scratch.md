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
# 
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
sudo apt install -y gawk texinfo bison xz-utils build-essential

# partitionを作成
sudo cfdisk /dev/sdb

> Select label type
gpt

> New
> Size: Enter
> Write -> YES
> Quit

# fdisk ver
su -
fdisk /dev/sdb
```
```
# fdisk session
Command (m for help): p
Disk /dev/sdb: 80 GiB, 85899345920 bytes, 167772160 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512
= 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xa4edc04a

Command (m for help): g
Created a new GPT disklabel (GUID: 18607BAC-CC25-47A1-AB1C-BD117540E78B).

Command (m for help): p
Disk /dev/sdb: 80 GiB, 85899345920 bytes, 167772160 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 18607BAC-CC25-47A1-AB1C-BD117540E78B

Command (m for help): n
Partition number (1-128, default 1):
First sector (2048-167772126, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-167772126, default 167770111):

Created a new partition 1 of type 'Linux filesystem' and of size 80 GiB.

Command (m for help): p
Disk /dev/sdb: 80 GiB, 85899345920 bytes, 167772160 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 18607BAC-CC25-47A1-AB1C-BD117540E78B

Device     Start       End   Sectors Size Type
/dev/sdb1   2048 167770111 167768064  80G Linux filesystem

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```

```sh
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

```sh
# 4.2 directory作成
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools


# 4.3 LFS user作成
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs

su - lfs
```

```sh
# 4.4 環境設定
# bashを非login shellとして起動する
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

# as root user
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF

source ~/.bash_profile
```

### 5章 build

```sh
# 確認
echo $LFS

# 必要なら再マウント
mount -v -t ext4 /dev/sdb1 /mnt/lfs

# /etc/fstab
# UUIDはlsblk -f or blkid /dev/sdb1で確認
21ba4d18-4240-4e9e-808e-dacdfb0ce853 /mnt/lfs ext4 defaults 0 2

# tar
tar -xf binutils-2.45.1.tar.xz
cd binutils-2.45.1
mkdir build
cd build

../configure --prefix=$LFS/tools \
  --with-sysroot=$LFS \
  --target=$LFS_TGT \
  --disable-nls \
  --enable-gprofng=no \
  --disable-werror \
  --enable-new-dtags \
  --enable-default-hash-style=gnu

make
make install
cd ../..
rm -rf binutils-2.45.1


# gcc
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0
# gcc srcの中に解凍する
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir build
cd build

../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.42 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make
make install
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
cd ..
rm -rf gcc-15.2.0

# Linux API Header
tar -xf linux-6.18.1.tar.xz
cd linux-6.18.1
make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
cd ..
rm -rf linux-6.18.1


# Glibc
tar -xf glibc-2.42.tar.xz
cd glibc-2.42
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac
patch -Np1 -i ../glibc-2.42-fhs-1.patch
mkdir build
cd build
echo "rootsbindir=/usr/sbin" > configparms
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4
make
make DESTDIR=$LFS install
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

# check
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
/mnt/lfs/lib/../lib/Scrt1.o succeeded
/mnt/lfs/lib/../lib/crti.o succeeded
/mnt/lfs/lib/../lib/crtn.o succeeded

grep -B3 "^ $LFS/usr/include" dummy.log
#include <...> search starts here:
 /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/include
 /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/15.2.0/include-fixed
 /mnt/lfs/usr/include

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
SEARCH_DIR("=/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib64")
SEARCH_DIR("=/usr/local/lib64")
SEARCH_DIR("=/lib64")
SEARCH_DIR("=/usr/lib64")
SEARCH_DIR("=/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib")
SEARCH_DIR("=/usr/local/lib")
SEARCH_DIR("=/lib")
SEARCH_DIR("=/usr/lib");

grep "/lib.*/libc.so.6 " dummy.log
attempt to open /mnt/lfs/usr/lib/libc.so.6 succeeded

grep found dummy.log
found ld-linux-x86-64.so.2 at /mnt/lfs/usr/lib/ld-linux-x86-64.so.2

rm -v a.out dummy.log
cd ../../
lfs:/mnt/lfs/sources$rm -rf glibc-2.42


# libstdc++
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0
mkdir build
cd build
../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0

make
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
cd ../..
rm -rf gcc-15.2.0
```

### 6章

```sh
tar -xf m4-1.4.20.tar.xz
cd m4-1.4.20
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

```


## LFS and Standards

* [POSIX.1-2008](https://pubs.opengroup.org/onlinepubs/9699919799/)
* [Filesystem Hierarchy Standard(FHS) Version 3.0](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
* [Linux Standard Base(LSB) Version 5.0](https://refspecs.linuxfoundation.org/lsb.shtml)
