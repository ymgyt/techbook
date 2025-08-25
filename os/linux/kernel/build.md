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
