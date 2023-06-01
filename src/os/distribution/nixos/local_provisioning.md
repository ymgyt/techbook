# Local environment provisioning

local環境セットアップまでの道のり


## Memo

### Mac

1. nixのinstall
  * [determinate system](https://github.com/DeterminateSystems/nix-installer)を利用してinstallした

2. nix-darwin

```sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

```