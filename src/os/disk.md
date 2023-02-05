# Disk Device

## Partition

### Partition Table

diskの先頭領域にあるデータ構造。partitionに関するデータを保持する。  
formatとして以下の種類がある

* MBR(Master Boot Record)
* GUID Partition Table(GPT)

#### MBR

kernel boot時の情報を格納するMBRにあるテーブル情報。  
Boot時用なので格納できる情報が少ないという問題がある。

#### GUID Partition Table

GPT(Globally Unique Identifier Partition Table)とも。
