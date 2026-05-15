# DMI

Desktop Management Interface

## Hardwareの情報を取得したい

```sh
cat /sys/class/dmi/id/product_name
<product_name>
```

1. UEFIが起動時にSMBIOS entorypoint と table をメモリに置く
2. kernelが DMI decoderでtableを読んでsysfs 経由で公開する
