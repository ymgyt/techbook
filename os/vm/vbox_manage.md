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


