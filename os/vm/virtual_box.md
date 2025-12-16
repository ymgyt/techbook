# Virtual Box

* [OS BOX](https://www.osboxes.org/virtualbox-images/)
  * OSのimageがある
  * defaultのcredential `osboxes/osboxes.org`
* [Ubuntuのturoial](https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview)

## Install

```sh
# install
sudo apt install dkms ./virtualbox-<version>_amd64.deb

# 自身をvboxusersに追加する
sudo usermod -a -G vboxusers ${USER}
```

## Console mode

GUIではなくconsole mode?にする

```sh
sudo systemctl set-default multi-user.target
sudo systemctl reboot

# 必要ならsshの起動
sudo apt install -y openssh-server
systemctl status ssh


# 元に戻すには
sudo systemctl set-default graphical.target
```

## User追加

```sh
# user meの場合
sudo useradd -m me -s /bin/bash
sudo passwd me
sudo usermod -a -G adm,sudo,vboxsf me 
```

## SSH

Settings > Network > Adapeter > Advanced > Port Forwarding

Add new rule >

* Name: ssh(なんでもいい)
* Protocol TCP
* Host Port: 3022(なんでもいい)
* Guest Port: 22

設定を反映したのち`ssh -p 3022 osboxes@127.0.0.1` (passはosboxes.org)
 
 
### Troubleshoot

####  Cannot register the hard disk <foo> <UUID> because a hard disk <bar> with <UUID> already exists.... To


`vboxmanage internalcommands sethduuid </path/to/new/virtual/disk.
vdi>`


### VirtualBox Guest Additions

0. install packages

  ```sh
  sudo apt update
  sudo apt install -y build-essential dkms linux-headers-$(uname -r)

  ```

1. VirtualBox > Devices > Insert Guest Additions CD Image
2. `sudo mount /dev/sr0 /media/cdrom`
3. `sudo sh /media/cdrom/VBoxLinuxAddtions.run`
4. `sudo sytemctl restart`
5.
  ```sh
  lsmod | grep vbox
  vboxsf                102400  0
  vboxguest             507904  6 vboxsf
  vboxvideo              61440  0
  ```

`vboxsf`,`vboxguest`,`vboxvideo`があればOK

aaa
