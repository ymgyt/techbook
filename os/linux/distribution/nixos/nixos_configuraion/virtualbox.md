# virtualbox

`configuration.nix`
```nix
{ config, pkgs, ... }: {

  imports = [ ./virtualbox.nix ];
}
```

`virtualbox.nix`
```nix
{ ... }: {
  virtualisation.virtualbox = {
    host.enable = true;
    # Guest additions
    guest.enable = true;
    guest.x11 = true;
  };
  users.extraGroups.vboxusers.members = [ "ymgyt" ];
}
```
