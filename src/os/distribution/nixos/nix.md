# Nix

## Install

https://nixos.org/download.html#nix-install-macos

`sh <(curl -L https://nixos.org/nix/install)`

`nix-shell -p nix-info --run "nix-info -m"`

## 世代管理(Generation)

* `/nix/var/nix/profiles/per-user/<user>`にinstall毎にsym linkが生成される
