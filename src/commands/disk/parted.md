# parted

partition editor。

## Disk情報の取得

```shell
parted -l
Model: VMware Virtual disk (scsi)
Disk /dev/sda: 107GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1075MB  1074MB  primary  xfs          boot
 2      1075MB  32.2GB  31.1GB  primary               lvm
 3      32.2GB  107GB   75.2GB  primary               lvm


Model: VMware Virtual disk (scsi)
Disk /dev/sdb: 107GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags: 

Number  Start   End    Size   Type     File system  Flags
 1      1049kB  107GB  107GB  primary
```

* `Partition Table`
  * `msdos`はMBR
