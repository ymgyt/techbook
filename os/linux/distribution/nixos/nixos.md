# NixOS

## Administration

```sh
# 電源off
# or shtudown
systemctl poweroff

# Reboot
systemctl reboot
```

* raspberry piの場合は`systemctl poweroff`したあと再度電源をいれると起動する


### Network

`/etc/nixos/configuratin.nix`

```nix
networking = {
  hostName = "my-hostname";
  defaultGateway = "192.168.1.1";
  nameservers = [ "8.8.8.8" ];
  interfaces.end0.ipv4.addresses = [ { 
    # 固定IP
    address = "192.168.1.2";
    prefixLength = 24;
  } ];
  wireless = {
    enable = false;
  };
};
```

* `networking.interfaces.<device>`は`ip addr`で確かめる
  * `ipv4.addresses`で固定IPを指定できる


## Install to Raspberry Pi 4

1. Get NixOS Image

```sh
nix-shell -p wget zstd

wget https://hydra.nixos.org/build/226381178/download/1/nixos-sd-image-23.11pre500597.0fbe93c5a7c-aarch64-linux.img.zst
unzstd -d nixos-sd-image-23.11pre500597.0fbe93c5a7c-aarch64-linux.img.zst
```

2. SD Cardをさす

```sh
# sd cardをさすと/dev/を表示してくれる
dmesg --follow

[ 3381.230145] mmc0: cannot verify signal voltage switch
[ 3381.334038] mmc0: new ultra high speed SDR104 SDXC card at address 59b4
[ 3381.349488] mmcblk0: mmc0:59b4 SD128 119 GiB
[ 3381.399498]  mmcblk0: p1
```

* 書き込み先が`/dev/mmcblk0`とわかる
  * `/dev/mmcblk0p1`はpartition

3. SD Cardに書き込む

```sh
sudo dd if=nixos-sd-image-23.11pre500597.0fbe93c5a7c-aarch64-linux.img of=/dev/sdX bs=4096 conv=fsync status=progress
```


4. Raspberry Piを起動

SD Cardをさして電源をいれる


5. `/etx/nixos/configuration.nix`の設定

6. `nixos-rebuild boot`

`sudo -i`している前提。  
その後 `systemctl reboot`

7 Update firmware

```sh
nix-shell -p raspberrypi-eeprom
mount /dev/disk/by-label/FIRMWARE /mnt
BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable rpi-eeprom-update -d -a
```

`sudo -i` している前提

### 参考

* [公式 Installing NixOS on a Raspberry Pi](https://nix.dev/tutorials/nixos/installing-nixos-on-a-raspberry-pi)


## Setup Clean NixOS

新しいLinux PCにNixOSを設定する手順

0. NixOSのinstallが済んでいる前提
1. mynixの設定

* 今から設定するhostnameをfooとする
* mynixにはfoo用のnixosConfigurationが設定されている
  * ただしhardware-configuration.nixだけはまだ作成されていない

```sh
nix shell nixpkgs#git --extra-experimental-features 'flakes nix-command'
git clone https://github.com/ymgyt/mynix.git
cd mynix
cp /etc/nixos/hardware-configuration.nix hosts/foo/
git add .
sudo nixos-rebuild switch --flake '.#foo' --show-trace
```

2. helixのinstall

```sh
nix profile install github:ymgyt/helix/explorer
```

## References


