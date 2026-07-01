# virt-install

```sh
(
virt-install
  --connect qemu:///system
  --virt-type=kvm
  --name vm01
  --vcpus 2
  --ram 4096
  --os-variant rhel8.0
  --cdrom /var/lib/libvirt/images/debian-13.5.0-amd64-netinst.iso
  --network network=default
  --graphics vnc
  --disk size=16
)
```
