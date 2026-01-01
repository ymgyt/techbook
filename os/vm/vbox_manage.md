# VBoxManage

VirtualBox CLI

```sh
# List VMs
# --longをつけると詳細表示(list共通)
VBoxManage list vms [--long]

# 動作しているVMs
VBoxManage list runningvms

# VMの起動
VBoxManage startvm
```

* `startvm`
  * `--type=<gui|headless|sdl|separate>` 起動モードの指定


## VMの作成

```sh
# OS typeの取得
VBoxManage list ostype

# 作成
VBoxManage createvm --name debian13-lfs --ostype Debian13_64  --register --basefolder $HOME/VirtualBoxVMs


Virtual machine 'debian13-lfs' is created and registered.
UUID: 0c023dad-466d-484d-804e-f723ae0246e6
Settings file: '/home/me/VirtualBoxVMs/debian13-lfs/debian13-lfs.vbox'
```

## VMの設定

```nu
(VBoxManage debian13-lfs 
  --memory 4096
  --cpus 4
  --firmware bios
  --rtc-use-utc on
  --audio-driver none
  --usb-xhci off
)

VBoxManage showvminfo debian13-lfs --macineredable
```

* `--memory`: allocateするRAM MB単位
* `--firmware=bios | efi | efi32 | efi64`: VMをbootするfirmware

## Diskの作成

```nu
VBoxManage createmedium disk --filename path/root.vdi --size 20480 --format VDI
```
