# MacOS Specific 

## linux builder

* Mac上にLinuxのVMを起動し、remote builderに指定することでmacでlinuxのfalkeをbuildすることができる

```sh
# 特に他の設定をせずに起動できた
# remote builderを起動したい場合はこれを実行したままにする
# 抜ける際はsystemctl poweroff
nix run nixpkgs#darwin.linux.builder
```

* manualだといくつか準備が必要そうだったが


* `/etc/nix/nix.conf`へ行う設定  
  * `~/.config/nix/nix.conf`ではダメだった
* nix-darwinがDO NOT EDITといっているが無視した

```
extra-trusted-users = ymgyt

# ${ARCH}はhostにあわせて"aarch64" or "x86_64"を指定する
# ${MAX_JOBS}は困ったら4
builders = ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

builders-use-substitutes = true
```

* `/etc/ssh/ssh_config.d/100-linux-builder.conf`
  * ssh接続しているらしいので解決できるようにする

```
Host linux-builder
  Hostname localhost
  HostKeyAlias linux-builder
  Port 31022
```

* nix daemonのrestart
  * `sudo launchctl kickstart -k system/org.nixos.nix-daemon`

* 参考
  * [Manual darwin.linux-builder](https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder)
