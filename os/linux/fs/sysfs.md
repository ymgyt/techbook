# sysfs

* virtual file system
  * `/proc`のprocfsより新しい仕組み
  * `/proc`を整理する目的もあったらしい
  * `/sys`にmountされる
* kernelの情報をuserspaceに提供するためにある
  * kobjectに対応する
* kernelの`Documentation/filesystems/sysfs.txt`にdocがある

```sh
eza -T -L 1 /sys
/sys
├── block
├── bus
├── class
├── dev
├── devices
├── firmware
├── fs
├── hypervisor
├── kernel
├── module
└── power
```
