# Segment

* 16bit自体(8086)に16bit以上のメモリ領域にアクセスするために、16bitのsegmentation registerの値を4bit左にshiftしてからプログラムのアドレス(16bit)と和をとっていた
  * 16bit(64KiB)の物理アドレス空間を1MiBに拡張できた

* 32bit化
  * segment registerはGDTのindexを格納するようになった
  * GDTにはメモリ保護情報が格納

* Segment registers
  * CS,DS,ES,FS,GS,SSの6個

* 64bit自体でもGDTのsegment registersは存在する

## GDT
