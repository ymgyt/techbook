# Device Mapper

* filesystem と block device driver の間の抽象化レイヤー
* 複数のblock device をまとめて仮想的なblock device をfilesystem にみせる
  * 複数ディスクを一つにみせたりできる

* LVMはdevice mapperを操作するuserspace utility

## Mapping

```text
filesystem
  ↓
/dev/dm-0
  ↓
device mapper
  ↓
/dev/sda1
```

* /dev/dm-0 の sector 0〜999 を /dev/sda1 の sector 2048〜3047 に対応させる

## target

* 変換ロジックをtargetという
