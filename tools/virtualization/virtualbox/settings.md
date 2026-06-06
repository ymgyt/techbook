# Virtual Machine Settings

VM Instanceの設定について

## Display

Display > Screen

* Video Memory: 128MBが推奨らしい
* FEtures 3D Accelerationを有効(check) 

## Network

* Enable Network Adapterを有効
* Attached to `Bridged Adapter`(ブリッジアダプター)
  * HostのnetworkのDHCPからIPをもらえる
* `NAT`
  * 外には出れる


## VirtualBox Guest Additions

0. install packages

  ```sh
  sudo apt update
  sudo apt install -y build-essential dkms linux-headers-$(uname -r)

  ```

1. VirtualBox > Devices > Insert Guest Additions CD Image
2. `sudo mount /dev/sr0 /media/cdrom`
3. `sudo sh /media/cdrom/VBoxLinuxAddtions.run`
4. `sudo usermod -a G vboxsf $USER`
5. `sudo sytemctl restart`
6.
  ```sh
  lsmod | grep vbox
  vboxsf                102400  0
  vboxguest             507904  6 vboxsf
  vboxvideo              61440  0
  ```

`vboxsf`,`vboxguest`,`vboxvideo`があればOK

### Shared Folders

* folder path: Host OSのpath
* folder name: mount時に使われるfoler name
* mount point: guestの指定された絶対pathにmountされる


## SSH

1. install ssh-server 
  ```sh
  sudo apt install -y openssh-server
  sudo systemctl enable ssh
  systemctl status ssh
  ```

2. check ip
  ```sh
  # 192.168.4.227とわかる
  vboxuser@vbox:~$ ip addr
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
      inet 127.0.0.1/8 scope host lo
         valid_lft forever preferred_lft forever
      inet6 ::1/128 scope host noprefixroute 
         valid_lft forever preferred_lft forever
  2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
      link/ether 08:00:27:ca:6e:71 brd ff:ff:ff:ff:ff:ff
      altname enx080027ca6e71
      inet 192.168.4.227/22 brd 192.168.7.255 scope global dynamic noprefixroute enp0s3
         valid_lft 85709sec preferred_lft 85709sec
      inet6 fe80::a00:27ff:feca:6e71/64 scope link noprefixroute 
         valid_lft forever preferred_lft forever
  
  ```

3. ssh
  ```sh
  # in host
  ssh $VMUSER@192.168.4.227
  ```
