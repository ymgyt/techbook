# Virtual Box

* [OS BOX](https://www.osboxes.org/virtualbox-images/)
  * OSのimageがある
  * defaultのcredential `osboxes/osboxes.org`
* [Ubuntuのturoial](https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview)

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


### VirtualBox Guest Additions?

* UI > Machine
* mount
* run .run
