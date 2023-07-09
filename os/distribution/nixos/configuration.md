# Configuration

設定fileは`/etc/nixos/configuration.nix`

data sourceはnix-channelに頼っているのでreproducibilityがflakesに比べて落ちる

`sudo nixos-rebuild switch`

### Options

何が設定できるか以下を検索

* [NixOS Options Search](https://search.nixos.org/options)
* [Manual](https://nixos.org/manual/nixos/unstable/index.html#ch-configuration)


## `/etc/nixos/configuration.nix`

```nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # enable Nix Flakes and the new nix-command command line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    # Nix Flakes uses the git command to pull dependencies from data sources, so git must be installed first
    git
    wget
  ];
}
```

### Flake

`nix.settings.experimental-features = [ "nix-command" "flakes" ];`  
flakesを有効にすると`/etc/nixos/flake.nix`が優先される
