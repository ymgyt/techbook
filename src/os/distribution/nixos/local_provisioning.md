# Local environment provisioning

local環境セットアップまでの道のり


## `/etc/nixos/configuration.nix`

data sourceはnix-channelに頼っているのでreproducibilityがflakesに比べて落ちる

`sudo nixos-rebuild switch`