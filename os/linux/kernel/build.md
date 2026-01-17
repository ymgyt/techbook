# Kernel Build 

1. kernelのsourceを取得する(git clone)
2. Configure
  * `make menuconfig`
3. Build kernel image, loadable modules, DeviceTreeBlobs(DTB)
  * `make [-j'n'] all`
4. Install built kernel modules
  * `sudo make INSTALL_MOD_PATH=<prefix-dir> modules_install`
5. Setup GRUB bootloader and `initramfs` (`initrd`) image
  * `sudo make [INSTALL_PATH=</new/boot/dir] install`


## Kbuild

```sh
# Clean .config
make mrproper

# defaultの.configを生成する
make defconfig

# distributionのbuild設定
/boot/config-$(uname -r)

# .configに新しいconfigをinteractiveに適用する
make oldconfig

# .configに新しいconfigをdefconfigに従って適用する
make olddefconfig
```

* `defconfig`
  * そのarchのdefault設定を適用する

* `oldconfig`
  * `.config`をベースに新規のconfigをinteractiveに追加していく

* `olddefconfig`
  * `.config`をベースに新規のconfigをdefconfigの値を自動で追加していく
  * `.config`を使いつつ、新規はdefault値を利用したい場合に便利

* `localmodconfig`
  * 現在実行中のconfigを取得したのち、`lsmod`して利用されているmoduleのみを有効にしてくれる

### Rust-for-linux

```sh
cp /boot/config-$(uname -r) .config
make olddefconfig

# lsmodで使われているものだけ対象になる
make localmodconfig

# 言われた
./scripts/config --enable VBOXGUEST
./scripts/config --enable VBOXSF
./scripts/config --enable VBOXVIDEO

su -c "make modules_install install"
# sudoじゃだめ?
sudo make modules_install
sudo make install
```

#### apt packages

```sh
sudo apt-get install -y build-essential bc bison flex libelf-dev dwarves pahole libssl-dev python3 perl pkg-config
```

### LLVM

```sh
make LLVM=1

# 実態としては以下に展開される
make \
  CC=clang \
  LD=ld.lld \
  AR=llvm-ar \
  NM=llvm-nm \
  STRIP=llvm-strip \
  OBJCOPY=llvm-objcopy \
  OBJDUMP=llvm-objdump \
  READELF=llvm-readelf \
  HOSTCC=clang \
  HOSTCXX=clang++ \
  HOSTAR=llvm-ar \
  HOSTLD=ld.lld
```

### Helixでcode jump

```sh
# 依存をsetup
nix develop github:ymgyt/derivers

# ccはgcc wrapperを想定
# clangはunwrappedだけど、ccはglibcをみせたいのでwrapperがほしい
which cc
/nix/store/r9wbjib6xxjkyb9yvjvrkl4sq61i2lyn-gcc-wrapper-15.2.0/bin/cc

make HOSTCC=cc LLVM=1 defconfig
make HOSTCC=cc LLVM=1 prepare

bear -- make HOSTCC=cc LLVM=1 -j8
# compile_commands.jsonができる

# clangdがみえている
hx --health c
```

### HOSTCC

cで書かれた補助プログラムをbuildすることがある。
kernelではなく普通のcをbuildするのでglibc headerが必要になる
nixでsetupしたunwrapped clangだとglibcがみえなかったりする、一方で、wrapped clangだとkernelのflagと食合せが悪い
