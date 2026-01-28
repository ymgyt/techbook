# mknod

```sh
# /dev/devone fileを作成する
# major numberは/proc/devicesから探している
sudo mknod --mode=666 /dev/devone c (rg devone /proc/devices | awk '{print $1;}') 0
```
