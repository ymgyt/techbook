# QEMU Edu Driver Development

## Memo

```sh
# base imageを取得
curl -sSfL -o debian-13-nocloud-amd64.qcow2 https://cloud.debian.org/images/cloud/trixie/latest/debian-13-nocloud-amd64.qcow2

# base imageをreadonlyで使うのでoverlayを作成
qemu-img create -f qcow2 -b ../../images/debian-13-nocloud-amd64.qcow2 -B qcow2 domains/edu-deb13/overlay.qcow2
```
