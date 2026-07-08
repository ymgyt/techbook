# qemu-img

```sh
# imageの情報を表示
qemu-img info debian-13-nocloud-amd64.qcow2

# base imageを指定してoverlay imageを作成 
qemu-img create -f qcow2 -b ../../images/debian-13-nocloud-amd64.qcow2 -B qcow2 domains/edu-deb13/overlay.qcow2```
