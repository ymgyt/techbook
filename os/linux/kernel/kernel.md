# kernel

* [Doc](https://www.kernel.org/doc/html/latest/#)

## Version

* mainorが19を超えるとmajorが上がるらしい(finters and toes: 手と足の指 model)
  * 4.19 -> 5.0
* 6-10 weeksでminorがあがる
* 6.0から2 weekのmerge windowが始まってその後、6.1-rc1, 6.1-rc2,... 6.1に至る

* [LinuxVersions](https://kernelnewbies.org/LinuxVersions)

* `https://www.kernel.org/finger_banner`でversionに関する情報がみれる

```sh
curl -L https://www.kernel.org/finger_banner
The latest stable version of the Linux kernel is:             6.8.9
The latest mainline version of the Linux kernel is:           6.9-rc7
The latest stable 6.8 version of the Linux kernel is:         6.8.9
The latest longterm 6.6 version of the Linux kernel is:       6.6.30
The latest longterm 6.1 version of the Linux kernel is:       6.1.90
The latest longterm 5.15 version of the Linux kernel is:      5.15.158
The latest longterm 5.10 version of the Linux kernel is:      5.10.216
The latest longterm 5.4 version of the Linux kernel is:       5.4.275
The latest longterm 4.19 version of the Linux kernel is:      4.19.313
The latest linux-next version of the Linux kernel is:         next-20240510
```

## srcの取得

```sh
 git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
```


## Memo

bootに必須の要素
* bootloader
* kernel
* root filesystem

optional
* もしCPUがARM/PPCなら DTB(Device Tree Blob) image file
* initramfs (initrd) image file

git clone https://github.com/PacktPublishing/Linux-Kernel-Programming_2E
