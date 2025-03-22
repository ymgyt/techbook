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

